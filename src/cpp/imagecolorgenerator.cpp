#include "imagecolorgenerator.h"

#include <QBuffer>
#include <QFileDialog>
#include <QImageReader>
#include <QPointer>
#include <QtConcurrent/QtConcurrentRun>
#include <QtMinMax>

#include <array>

ImageColorGenerator::ImageColorGenerator(QObject *parent)
    : Generator{parent}
{
    connect(&m_watcher, &QFutureWatcher<Result>::finished,
            this, &ImageColorGenerator::finishGeneration);
}

ImageColorGenerator *ImageColorGenerator::instance()
{
    static ImageColorGenerator generator;
    return &generator;
}

void ImageColorGenerator::setBusy(bool busy)
{
    if (m_busy == busy)
        return;

    m_busy = busy;
    emit busyChanged();
}

void ImageColorGenerator::openImage(int colorCount)
{
    if (m_busy)
        return;

    colorCount = qBound(1, colorCount, 10);
    m_error.clear();
    emit resultChanged();
    setBusy(true);

#ifdef Q_OS_WASM
    // Browser: Die ausgewählte Datei wird asynchron als Bytes geliefert.
    const QPointer<ImageColorGenerator> guard(this);

    QFileDialog::getOpenFileContent(
        QStringLiteral("Bilder (*.png *.jpg *.jpeg)"),
        [guard, colorCount](const QString &fileName, const QByteArray &data) {
            if (!guard)
                return;

            if (fileName.isEmpty()) {
                guard->setBusy(false);
                return;
            }

            guard->startGeneration(fileName, data, colorCount);
        });
#else
    // Windows: Nur den Pfad auswählen; gelesen wird im Hintergrundthread.
    auto *dialog = new QFileDialog;
    dialog->setWindowTitle(QStringLiteral("Bild auswählen"));
    dialog->setFileMode(QFileDialog::ExistingFile);
    dialog->setNameFilter(QStringLiteral("Bilder (*.png *.jpg *.jpeg)"));
    dialog->setWindowModality(Qt::ApplicationModal);

    connect(dialog, &QDialog::finished, this,
            [this, dialog, colorCount](int result) {
                const QStringList files = dialog->selectedFiles();
                dialog->deleteLater();

                if (result != QDialog::Accepted || files.isEmpty()) {
                    setBusy(false);
                    return;
                }

                startGeneration(files.first(), {}, colorCount);
            });

    dialog->open();
#endif
}

void ImageColorGenerator::startGeneration(const QString &fileName,
                                          const QByteArray &data, int colorCount)
{
    // Nur Daten kopieren. Der Worker greift nicht auf QML oder dieses QObject zu.
    m_watcher.setFuture(QtConcurrent::run([fileName, data, colorCount] {
        return processImage(fileName, data, colorCount);
    }));
}

void ImageColorGenerator::finishGeneration()
{
    // Dieser Slot läuft wieder im GUI-Thread.
    const Result result = m_watcher.result();
    m_error = result.error;

    if (m_error.isEmpty()) {
        m_colors = result.colors;
        m_imageSource = result.imageSource;
    }

    emit resultChanged();
    setBusy(false);
}

ImageColorGenerator::Result ImageColorGenerator::processImage(
    const QString &fileName, const QByteArray &data, int colorCount)
{
    Result result;
    QBuffer buffer;
    QImageReader reader;

#ifdef Q_OS_WASM
    Q_UNUSED(fileName);
    buffer.setData(data);
    buffer.open(QIODevice::ReadOnly);
    reader.setDevice(&buffer);
#else
    Q_UNUSED(data);
    reader.setFileName(fileName);
#endif

    reader.setAutoTransform(true);

    const QByteArray format = reader.format().toLower();
    if (format != "png" && format != "jpeg" && format != "jpg") {
        result.error = QStringLiteral("Bitte ein gültiges PNG- oder JPEG-Bild auswählen.");
        return result;
    }

    // Bewusste Speichergrenze für die Browser-Version: maximal 16 Megapixel.
    const QSize size = reader.size();
    if (!size.isValid() || qint64(size.width()) * size.height() > 16000000) {
        result.error = QStringLiteral("Das Bild darf höchstens 16 Megapixel enthalten.");
        return result;
    }

    QImage image = reader.read();
    if (image.isNull()) {
        result.error = reader.errorString();
        return result;
    }

    image = image.convertToFormat(QImage::Format_ARGB32);
    if (image.isNull()) {
        result.error = QStringLiteral("Nicht genügend Speicher für das Bild.");
        return result;
    }

    result.colors = extractColors(image, colorCount);
    if (result.colors.isEmpty()) {
        result.error = QStringLiteral("Das Bild enthält keine ausreichend sichtbaren Pixel.");
        return result;
    }

    result.imageSource = createPreview(image);
    if (result.imageSource.isEmpty())
        result.error = QStringLiteral("Die Bildvorschau konnte nicht erstellt werden.");

    return result;
}

QVariantList ImageColorGenerator::extractColors(const QImage &image, int colorCount)
{
    struct BrightnessBucket {
        quint64 count = 0;
        quint64 red = 0;
        quint64 green = 0;
        quint64 blue = 0;
    };

    std::array<BrightnessBucket, 256> buckets{};

    for (int row = 0; row < image.height(); ++row) {
        const auto *pixels = reinterpret_cast<const QRgb *>(image.constScanLine(row));

        for (int column = 0; column < image.width(); ++column) {
            const QRgb pixel = pixels[column];
            if (qAlpha(pixel) < 128)
                continue;

            auto &bucket = buckets[qGray(pixel)];
            ++bucket.count;
            bucket.red += qRed(pixel);
            bucket.green += qGreen(pixel);
            bucket.blue += qBlue(pixel);
        }
    }

    // GEÄNDERT: jede vorhandene Helligkeitsgruppe nur einmal berücksichtigen
    QList<QColor> candidates;
    candidates.reserve(256);

    for (const auto &bucket : buckets) {
        if (bucket.count == 0)
            continue;

        const QColor color(
            int(bucket.red / bucket.count),
            int(bucket.green / bucket.count),
            int(bucket.blue / bucket.count));

        // GEÄNDERT: auch Rundungsduplikate ausschließen
        if (!candidates.contains(color))
            candidates.append(color);
    }

    return selectBrightnessLevels(candidates, colorCount);
}

QString ImageColorGenerator::createPreview(const QImage &image)
{
    // Kleine Vorschau statt des vollständigen Bildes an QML übergeben.
    const QImage preview = image.scaled(640, 640, Qt::KeepAspectRatio,
                                        Qt::SmoothTransformation);

    QByteArray data;
    QBuffer buffer(&data);
    if (!buffer.open(QIODevice::WriteOnly) || !preview.save(&buffer, "PNG"))
        return {};

    return QStringLiteral("data:image/png;base64,") +
           QString::fromLatin1(data.toBase64());
}

QVariantList ImageColorGenerator::selectBrightnessLevels(
    const QList<QColor> &candidates, int colorCount)
{
    if (candidates.isEmpty() || colorCount <= 0)
        return {};

    QList<QColor> remaining = candidates;
    const auto brightnessLess = [](const QColor &left, const QColor &right) {
        return qGray(left.rgb()) < qGray(right.rgb());
    };
    std::sort(remaining.begin(), remaining.end(), brightnessLess);

    const int count = qMin(colorCount, int(remaining.size()));
    const qreal darkest = qGray(remaining.first().rgb());
    const qreal brightest = qGray(remaining.last().rgb());

    QList<QColor> selected;
    selected.reserve(count);

    for (int index = 0; index < count; ++index) {
        // NEU: gleichmäßige Helligkeitsabstände statt Pixelhäufigkeit
        const qreal position = count == 1 ? 0.5 : qreal(index) / (count - 1);
        const qreal target = darkest + (brightest - darkest) * position;

        const auto closest = std::min_element(
            remaining.begin(), remaining.end(),
            [target](const QColor &left, const QColor &right) {
                return qAbs(qGray(left.rgb()) - target)
                < qAbs(qGray(right.rgb()) - target);
            });

        selected.append(*closest);
        remaining.erase(closest); // NEU: diese Farbe kann nicht erneut gewählt werden
    }

    std::sort(selected.begin(), selected.end(), brightnessLess);

    QVariantList colors;
    colors.reserve(selected.size());
    for (const QColor &color : selected)
        colors.append(QVariant::fromValue(color));

    return colors;
}