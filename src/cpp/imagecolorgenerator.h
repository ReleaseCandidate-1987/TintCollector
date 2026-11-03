#ifndef IMAGECOLORGENERATOR_H
#define IMAGECOLORGENERATOR_H

#include "generator.h"

#include <QByteArray>
#include <QFutureWatcher>
#include <QImage>
#include <QObject>
#include <QString>
#include <QVariantList>

class ImageColorGenerator : public Generator
{
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(QString imageSource READ imageSource NOTIFY resultChanged)
    Q_PROPERTY(QVariantList colors READ colors NOTIFY resultChanged)
    Q_PROPERTY(QString error READ error NOTIFY resultChanged)

public:
    static ImageColorGenerator *instance();

    Q_INVOKABLE void openImage(int colorCount = 5);

    bool busy() const { return m_busy; }
    QString imageSource() const { return m_imageSource; }
    QVariantList colors() const { return m_colors; }
    QString error() const { return m_error; }

signals:
    void busyChanged();
    void resultChanged();

private:
    struct Result {
        QVariantList colors;
        QString imageSource;
        QString error;
    };

    explicit ImageColorGenerator(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(ImageColorGenerator)

    void setBusy(bool busy);
    void startGeneration(const QString &fileName, const QByteArray &data, int colorCount);
    void finishGeneration();

    static Result processImage(const QString &fileName, const QByteArray &data, int colorCount);
    static QVariantList extractColors(const QImage &image, int colorCount);
    static QString createPreview(const QImage &image);
    // NEU: unterschiedliche Farben nach Helligkeitsabstand auswählen
    static QVariantList selectBrightnessLevels(const QList<QColor> &candidates, int colorCount);
    QFutureWatcher<Result> m_watcher;
    bool m_busy = false;
    QString m_imageSource;
    QVariantList m_colors;
    QString m_error;
};

#endif // IMAGECOLORGENERATOR_H