#ifndef MODEL_H
#define MODEL_H

#include <QAbstractListModel>

class Model : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QStringList names READ names NOTIFY namesChanged)
public:
    explicit Model(QObject *parent = nullptr);

    /*! Erstellt ein Model mit zusätzlichen Rollen. */
    explicit Model(const QHash<int, QByteArray> &roles, QObject *parent = nullptr);

    /*! Hinzufügen eines neuen Items. */
    Q_INVOKABLE virtual void append(const QVariantMap &item);

    /*! Entfernt ein Item unter Angabe des Indizes. */
    Q_INVOKABLE virtual void remove(int index);

    /*! Beschafft unter Angabe des Indizes einen Eintrag. */
    Q_INVOKABLE QVariantMap get(int index) const;

    /*! Ändert einen Eintrag und setzt dabei die neue Eigenschaft. */
    Q_INVOKABLE void setProperty(int index, const QString &property, const QVariant &value);

    /*! Überprüft, ob siche bereits ein Name in den Items befindet. */
    Q_INVOKABLE bool containsName(const QString &name, int excludeIndex = -1);

    /*! Ändert den Namen eines Items über die setProperty Methode. */
    Q_INVOKABLE void rename(int index, const QString &newName);

    /*! Gibt die Anzahl der Einträge wieder. */
    int count() const;

    /*! Gibt eine Liste mit allen Namen wieder. */
    QStringList names() const;

    /*! NEU: Ersetzt alle Einträge und benachrichtigt die verbundenen Ansichten. */
    void setItems(const QVariantList &items);

    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

protected:
    QHash<int, QByteArray> m_roles;
    QVariantList m_items;

signals:
    void countChanged();
    void namesChanged();
};

#endif // MODEL_H