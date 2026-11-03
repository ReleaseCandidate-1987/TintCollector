#include "colorgenerator.h"
#include <qvariant.h>
#include <QDebug>
#include <cmath>

ColorGenerator::ColorGenerator(QObject *parent)
    : Generator{parent}
{
    m_colors = new Model({
                             {Qt::UserRole + 3, "colorCode"},
                             {Qt::UserRole + 4, "category"},
                             }, this);
}

ColorGenerator *ColorGenerator::instance()
{
    static ColorGenerator cg;
    return &cg;
}

Model *ColorGenerator::generatedColors(int currentMode, const QColor &baseColor, int colorCount, qreal value, qreal hue)
{
    QVariantList colors;

    if ( !baseColor.isValid() ) {
        m_colors->setItems(colors);
        return m_colors;
    }

    colors.reserve(colorCount);

    for ( int i = 0; i < colorCount; ++i ) {
        QVariantMap color;
        const auto clr = generateColor(currentMode, baseColor, i, colorCount, value, hue).name();
        color.insert("colorCode", clr);
        color.insert("category", 0);
        colors.append(color);
    }

    m_colors->setItems(colors);
    return m_colors;
}


void ColorGenerator::addColor(qint64 paletteID, int category, int index)
{
    const QStringList categoryNames = colorModel()->categoryNames();

    if (category < 0 || category >= categoryNames.size() ||
        index < 0 || index >= m_colors->count())
        return;

    const auto color = m_colors->get(index);
    const QString name = categoryNames.at(category).chopped(1);

    colorModel()->addColor(paletteID, name,
                           color.value("colorCode").toString(), category);
}

void ColorGenerator::addColors(qint64 paletteID, int category)
{
    for (int i = 0; i < m_colors->count(); ++i)
        addColor(paletteID, category, i);

    emit m_colors->countChanged();
}

QColor ColorGenerator::generateColor(int currentMode, const QColor &baseColor, int index, int colorCount, qreal value, qreal hue) const
{
    const qreal offset = static_cast<qreal>(index) / qMax(1, colorCount) * value;
    const qreal baseHue = qMax(0.0f, baseColor.hslHueF());
    const qreal saturation = baseColor.hslSaturationF();
    const qreal lightness = baseColor.lightnessF();
    const qreal alpha = baseColor.alphaF();

    switch (currentMode) {
    case 0: // Aufhellen
        return QColor::fromHslF(baseHue, saturation, lightness + (1 - lightness) * offset, alpha );

    case 1: // Abdunkeln
        return QColor::fromHslF(baseHue, saturation, lightness * (1 - offset ), alpha );

    case 2: // Sättigen
        return QColor::fromHslF(hue, saturation + (1-saturation) * offset, lightness, alpha );

    case 3: // Entsättigen
        return QColor::fromHslF(hue, saturation * (1 - offset), lightness, alpha);

    case 4: // Farbton drehen
        return QColor::fromHslF(
            std::fmod(hue + static_cast<qreal>(index) / colorCount * value, 1.0),
            saturation, lightness, alpha);

    case 5: // Zur Komplementärfarbe
        return QColor::fromHslF(std::fmod(hue + 0.5 * offset, 1.0), saturation, lightness, alpha);

    case 6: // Pastell
        return QColor::fromHslF(hue, saturation * (1 - 0.6 * offset),
                                lightness + (1 - lightness) * 0.7 * offset, alpha);

    case 7: // Transparenter
        return QColor::fromHslF(baseHue, saturation, lightness, alpha * (1 - offset));

    case 8: // Wärmer
        return QColor::fromRgbF(
            baseColor.redF() + (1 - baseColor.redF()) * offset,
            baseColor.greenF() + (0.5 - baseColor.greenF()) * offset,
            baseColor.blueF() * (1 - offset), alpha);

    case 9: // Kälter
        return QColor::fromRgbF(
            baseColor.redF() * (1 - offset),
            baseColor.greenF() + (0.5 - baseColor.greenF()) * offset,
            baseColor.blueF() + (1 - baseColor.blueF()) * offset, alpha);

    default:
        return baseColor;
    }
}

int ColorGenerator::count() const { return m_colors->count(); }

QStringList ColorGenerator::modes() const
{
    return {
        "Aufhellen", "Abdunkeln", "Sättigen",
        "Entsättigen", "Farbton drehen", "Zur Komplementärfarbe",
        "Pastell", "Transparenter", "Wärmer", "Kälter"
    };
}