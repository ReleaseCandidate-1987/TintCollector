#ifndef CLIPBOARD_H
#define CLIPBOARD_H

#include <QObject>

class Clipboard : public QObject
{
    Q_OBJECT
public:

    static Clipboard *instance();
    Q_INVOKABLE void setText( const QString &text );
signals:

private:
    explicit Clipboard(QObject *parent = nullptr);
};

#endif // CLIPBOARD_H
