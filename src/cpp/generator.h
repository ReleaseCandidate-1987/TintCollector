#ifndef GENERATOR_H
#define GENERATOR_H

#include "colormodel.h"

#include <QObject>

class Generator : public QObject
{
    Q_OBJECT
public:

    ColorModel *colorModel() const;
    void setColorModel(ColorModel *newColorModel);

signals:

protected:
    explicit Generator(QObject *parent = nullptr);

private:
    ColorModel *m_colorModel = nullptr;

};

#endif // GENERATOR_H
