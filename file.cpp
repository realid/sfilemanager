#include "file.h"

#include <QFileInfo>
#include <math.h>
#include <QDir>

File::File(QObject *parent)
    : QObject(parent)
{

}

File::File(QString name, QString dir, QObject *parent)
    :QObject(parent)
{
    QFileInfo fi(dir + "/" + name);
    wholeName_ = name;
    isFile_ = fi.isFile();
    parentDir_ = dir;
    if (name == ".." || name == ".") {
        name_ = name;
        type_ = "";
    } else {
        name_ = fi.baseName();
        if (isFile_)
            type_ = fi.suffix();
        else
            name_ = name;
        if (isFile_)
            size_ = converSize(fi.size());
        else {
            QDir myDir(dir + "/" + name);
            if (myDir.entryList().length() == 0)
                size_ = "0 items";
            else
                size_ = QString::number(myDir.entryList().length() - 2) + " items";
        }
    }
}

QString File::converSize(qint64 size)
{
    if (size > 1000000000)
        return QString::number(roundf(size/1000000000.0 * 10)/10) + " GB";
    else if (size > 1000000)
        return QString::number(roundf(size/1000000.0 * 10)/10) + " MB";
    else if (size > 1000)
        return QString::number(roundf(size/1000.0 * 10)/10) +" KB";
    else
        return QString::number(size) + " B";
}

QString File::icon()
{
    if (type_ == "jpg")
        return "/icons/jpg.png";
    else if (type_ == "doc")
        return "/icons/doc.png";
    else if (type_ == "" && isFile_ == false)
        return "/icons/folder.png";
    else if (type_ == "pdf")
        return "/icons/pdf.png";
    else
        return "/icons/default.png";
}
