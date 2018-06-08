#ifndef FILE_H
#define FILE_H

#include <QObject>

class File : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString wholeName READ wholeName NOTIFY wholeNameChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString type READ type NOTIFY typeChanged)
    Q_PROPERTY(QString size READ size NOTIFY sizeChanged)
    Q_PROPERTY(QString icon READ icon NOTIFY typeChanged)
public:
    explicit File(QObject *parent = nullptr);
    File(QString name, QString dir, QObject *parent = nullptr);
    QString wholeName() const { return wholeName_; }
    QString name() const { return name_; }
    QString type() const { return type_; }
    QString size() const { return size_; }
    QString icon();
    QString converSize(qint64 size);
signals:
    void wholeNameChanged();
    void nameChanged();
    void typeChanged();
    void sizeChanged();
public slots:

private:
    QString parentDir_;
    QString wholeName_;
    QString name_;
    QString type_;
    QString size_;
    bool isFile_;
};

#endif // FILE_H
