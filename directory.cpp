#include "directory.h"
#include "file.h"

#include <QDebug>
#include <QDir>
#include <QFileInfo>
#include <QDesktopServices>
#include <QUrl>

Directory::Directory()
{
    this->dir_ = QDir::drives().at(0).absoluteFilePath();
//    qDebug() << QDir::drives().at(0).absoluteFilePath();
    loadFiles();
}

void Directory::loadFiles()
{
    QDir directory(dir_);
    files_ = directory.entryList();
    m_files_.clear();
    for (int i = 0; i < files_.count(); i++) {
        QFileInfo fi(dir_ + "/" + files_.at(i));
        if (files_.at(i) == "." || files_.at(i) == "..")
            continue;
        if (fi.isDir())
            m_files_.append(new File(files_.at(i), dir_));
    }
    for (int i = 0; i < files_.count(); i++) {
        QFileInfo fi(dir_ + "/" + files_.at(i));
        if (!fi.isDir())
            m_files_.append(new File(files_.at(i), dir_));
    }
    emit filesChanged();
}

void Directory::changeDir(QString newDir)
{
    QFileInfo fi(newDir);
    if (fi.isDir()) {
        QDir myDir(newDir);
        if (myDir.entryList().length() == 0)
            return;
        dir_ = fi.absoluteFilePath();
        loadFiles();
    } else
        QDesktopServices::openUrl(QUrl("file:" + newDir));
}

QString Directory::dir()
{
    return dir_;
}

void Directory::copyToDir(QString file)
{
    QFileInfo f(file);
    qDebug() << file + " to " + dir_ + f.fileName();
    if(f.isFile()){
        QFile::copy(file, dir_ + '/' + f.fileName());
    }
    else{
        QDir(dir_).mkdir(f.baseName());
        this->copyPath(file, dir_ +'/'+f.baseName());
    }
    loadFiles();
}

void Directory::copyPath(QString src, QString dst)
{
    QDir dir(src);
    if (!dir.exists())
        return;

    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        QString dst_path = dst + QDir::separator() + d;
        dir.mkpath(dst_path);
        copyPath(src+ QDir::separator() + d, dst_path);
    }

    foreach (QString f, dir.entryList(QDir::Files)) {
        QFile::copy(src + QDir::separator() + f, dst + QDir::separator() + f);
    }
}

void Directory::moveToDir(QString file)
{
    QFileInfo f(file);
    QDir d;
    if (f.isFile())
        d.rename(file, dir_ + '/' + f.baseName());
    else {
        QDir(dir_).mkdir(f.baseName());
        copyPath(file, dir_ + "/" + f.baseName());
        removeDir(file);
    }
    loadFiles();
}

void Directory::cdUp()
{
    QDir d(dir_);
    d.cdUp();
    this->changeDir(d.absolutePath());
    this->loadFiles();
}

void Directory::newFolder(QString name)
{
    if (!QDir(dir_ + '/' + name).exists())
        QDir().mkdir(dir_ + '/' + name);
    loadFiles();
}

void Directory::newFile(QString name)
{
    if (!QFile(dir_ + '/' + name).exists()) {
        QFile f(dir_ + '/' + name);
        f.open(QIODevice::WriteOnly);
        loadFiles();
    }
}

void Directory::deleteFile(QString file, bool emitFlag)
{
    QFileInfo f(dir_ + "/" + file);
    if (f.isFile())
        QFile::remove(dir_ + "/" + file);
    else
        removeDir(dir_ + "/" + file);
    if (emitFlag)
        loadFiles();
}

bool Directory::removeDir(const QString &dirName)
{
    bool result = true;
    QDir dir(dirName);

    if (dir.exists(dirName)) {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::System | QDir::Hidden  | QDir::AllDirs | QDir::Files, QDir::DirsFirst)) {
            if (info.isDir())
                result = removeDir(info.absoluteFilePath());
            else
                result = QFile::remove(info.absoluteFilePath());

            if (!result) {
                return result;
            }
        }
        result = dir.rmdir(dirName);
    }
    return result;
}

void Directory::rename(QString oldName, QString newName)
{
    QDir d;
    d.rename(dir_ + '/'+ oldName, dir_ + '/' + newName);
    loadFiles();
}

void Directory::refresh()
{
    loadFiles();
}
