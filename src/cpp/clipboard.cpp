#include "clipboard.h"

#include <QGuiApplication>
#include <QClipboard>

Clipboard::Clipboard(QObject *parent)
    : QObject{parent}
{}

Clipboard *Clipboard::instance()
{
    static Clipboard cb;
    return &cb;
}

void Clipboard::setText(const QString &text)
{
    QGuiApplication::clipboard()->setText(text);
}

