#include "filesystemtreemodel.h"

FileSystemTreeModel::FileSystemTreeModel(QObject *parent)
    : QFileSystemModel(parent)
{

}

FileSystemTreeModel::~FileSystemTreeModel()
{

}

QString FileSystemTreeModel::filePath(QModelIndex index)
{
    return QFileSystemModel::filePath(index);
}

//QVariant FileSystemTreeModel::data(const QModelIndex &index, int role) const
//{
//    return QFileSystemModel::data(index, role);
//}

//int FileSystemTreeModel::rowCount(const QModelIndex &parent) const
//{
//    return QFileSystemModel::rowCount(parent);
//}
