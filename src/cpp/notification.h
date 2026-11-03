#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QObject>

class Notification : public QObject
{
    Q_OBJECT
public:
    enum NotificationType { Success, Information, Error };

    static Notification *instance();
    void setMessage(const QString &text, Notification::NotificationType type);
private:
    explicit Notification(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(Notification)

signals:
    void requested(const QString &, Notification::NotificationType);
};

#endif // NOTIFICATION_H
