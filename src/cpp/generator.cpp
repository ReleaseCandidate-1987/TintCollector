#include "generator.h"

Generator::Generator(QObject *parent)
    : QObject{parent}
{}

ColorModel *Generator::colorModel() const
{
    return m_colorModel;
}

void Generator::setColorModel(ColorModel *newColorModel)
{
    m_colorModel = newColorModel;
}
