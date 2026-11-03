#include "notification.h"


Notification::Notification(QObject *parent)
    : QObject{parent}
{}


Notification *Notification::instance()
{
    static Notification n;
    return &n;
}

void Notification::setMessage(const QString &text, NotificationType type)
{
    emit requested(text, type);
}
