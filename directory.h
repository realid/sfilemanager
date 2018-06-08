#ifndef DIRECTORY_H
#define DIRECTORY_H

#include <QString>
#include <QDir>
#include <QStringList>
#include <QObject>

class Directory : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject *> files READ files NOTIFY filesChanged)
public:
    Directory();
    QList<QObject *> files() const { return m_files_; }
    void loadFiles();
    Q_INVOKABLE void changeDir(QString newDir);
    Q_INVOKABLE QString dir();
    Q_INVOKABLE void copyToDir(QString file);
    Q_INVOKABLE void moveToDir(QString file);
    Q_INVOKABLE void cdUp();
    Q_INVOKABLE void deleteFile(QString file, bool emitFlag);
    Q_INVOKABLE void rename(QString oldName, QString newName);
    Q_INVOKABLE void newFolder(QString name);
    Q_INVOKABLE void newFile(QString name);
    Q_INVOKABLE void refresh();
    void copyPath(QString src, QString dst);
    bool removeDir(const QString &dirName);

signals:
    void filesChanged();

public slots:

protected:
    QList<QObject *> m_files_;
    QString dir_;
    QStringList files_;
    QStringList selectedFiles_;
};

#endif // DIRECTORY_H
