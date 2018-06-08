#ifndef FILESYSTEMTREEMODEL_H
#define FILESYSTEMTREEMODEL_H

#include <QFileSystemModel>

class FileSystemTreeModel : public QFileSystemModel
{
    Q_OBJECT
public:
    explicit FileSystemTreeModel(QObject *parent = Q_NULLPTR);
    ~FileSystemTreeModel();

    Q_INVOKABLE QString filePath(QModelIndex index);

//    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
//    int rowCount(const QModelIndex &parent) const Q_DECL_OVERRIDE;
//    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;
};

#endif // FILESYSTEMTREEMODEL_H
