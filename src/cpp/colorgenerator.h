
#ifndef COLORGENERATOR_H
#define COLORGENERATOR_H

#include "generator.h"
#include "model.h"
#include <QColor>
#include <QObject>
#include <QVariant>

class ColorGenerator : public Generator
{
    Q_OBJECT
    Q_PROPERTY(QStringList modes READ modes CONSTANT)
    Q_PROPERTY(int count READ count  NOTIFY countChanged FINAL)

public:
    static ColorGenerator *instance();

    Q_INVOKABLE Model *generatedColors(int currentMode, const QColor &baseColor, int colorCount, qreal value, qreal hue);

    Q_INVOKABLE void addColors(qint64 paletteID, int category);

    // Eine einzelne generierte Farbe hinzufügen.
    Q_INVOKABLE void addColor(qint64 paletteID, int category, int index);

    QStringList modes() const;
    int count() const;

signals:
    void countChanged();

private:
    explicit ColorGenerator(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(ColorGenerator)

    QColor generateColor(int currentMode, const QColor &baseColor, int index, int colorCount, qreal value, qreal hue) const;

private:
    Model *m_colors;
};

#endif // COLORGENERATOR_H
