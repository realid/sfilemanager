import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import directory 1.0

ApplicationWindow {
    visible: true
    width: 1280
    minimumWidth: 800
    height: 720
    minimumHeight: 600
    x: 200
    y: 100
    title: qsTr("FileManager")
    color: Qt.rgba(backgroundColorOfWholeAppRed, backgroundColorOfWholeAppGreen, backgroundColorOfWholeAppBlue, 1)

    property real backgroundColorOfWholeAppRed: 0.9
    property real backgroundColorOfWholeAppGreen: 0.9
    property real backgroundColorOfWholeAppBlue: 0.9

    property int cellWidth: 100
    property int cellHeight: 100

    property int fontSize: 12

//    Menu {
//        title: qsTr("Edit")
//        id: contextMenu
//    }


    menuBar: MenuBar {
        style: MenuBarStyle{
        }

        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("New Window")
                shortcut: "Ctrl+N"
            }
            MenuItem {
                text: qsTr("New Folder")
                shortcut: "Shift+Ctrl+N"
            }

            MenuItem {
                text: qsTr("New File")
                shortcut: "Shift+Ctrl+N"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Open")
                shortcut: "Ctrl+O"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Attribute")
                shortcut: "Alt+Enter"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Close")
                shortcut: "Ctrl+W"
            }
            MenuItem {
                text: qsTr("Close all Windows")
                shortcut: "Ctrl+Q"
            }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("Cut")
                shortcut: "Ctrl+X"
            }
            MenuItem {
                text: qsTr("Copy")
                shortcut: "Ctrl+C"
            }
            MenuItem {
                text: qsTr("Paste")
                shortcut: "Ctrl+V"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Select")
                shortcut: "Ctrl+A"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Rename")
                shortcut: "F2"
            }

            MenuSeparator { }
            MenuItem {
                text: qsTr("Delete")
                shortcut: "Delete"
            }
        }

        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("About HTFM")
            }
        }
    }

    toolBar: ToolBar {
        id: tool
        style: ToolBarStyle {
            background: Rectangle { color: Qt.rgba(backgroundColorOfWholeAppRed, backgroundColorOfWholeAppGreen, backgroundColorOfWholeAppBlue, 1) }
        }
        height: 42
        RowLayout {
            anchors.fill: parent
            ToolButton {
                iconSource: "qrc:/icons/toolbar/go-home.png"
            }
            ToolButton {
                iconSource: "qrc:/icons/toolbar/go-previous.png"
            }
            ToolButton {
                iconSource: "qrc:/icons/toolbar/go-next.png"
            }
            Item { Layout.fillWidth: true }
            ToolButton {
                iconSource: "qrc:/icons/toolbar/edit-find.png"
            }
            ToolButton {
                iconSource: "qrc:/icons/toolbar/view-list.png"
            }
        }
    }

    SplitView {
        id: mainWindow
        anchors.fill: parent
        orientation: Qt.Horizontal
        Directory {
            id: directory
        }
        Rectangle {
            width: 200
            Layout.maximumWidth: 400
            color: Qt.rgba(backgroundColorOfWholeAppRed, backgroundColorOfWholeAppGreen, backgroundColorOfWholeAppBlue, 1)

            MouseArea {
                anchors.fill: parent
                onClicked: console.debug("clicked")
            }

            TreeView {
                id: fileSystemTree
                anchors.fill: parent
                headerVisible: false
                width: parent.width
                model: fileSystemTreeModel
//                rootIndex: rootPathIndex
                frameVisible: false
                alternatingRowColors: false
                focus: true
//                backgroundVisible: false

                itemDelegate: Component {
                    Item {
                        Image {
                            id: image
                            width: 18
                            height: 16
                            source: "/icons/folder.png"
                        }

                        Text {
                            anchors.left: image.right
                            text: styleData.value == "/" ? qsTr("Computer") : styleData.value
                            color: styleData.selected ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    role: "fileName"
                    title: "Name"
                }

                onClicked: {
                    directory.changeDir(model.filePath(index));
                }

                onDoubleClicked: {
                    isExpanded(index) ? collapse(index) : expand(index);
                    console.debug(index);
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Component {
                id: gridViewDelegate
                Item {
                    id: item
                    width: gridView.cellWidth
                    height: gridView.cellHeight
                    state: ""
                    objectName: "cell"
                    property var name: modelData.name
                    Rectangle {
                        id: imageSelected
                        objectName: "Rectangle"
                        width: itemImage.width + 5
                        height: itemImage.height + 5
                        color: "lightgray"
                        anchors.centerIn: itemImage
                        radius: 5
                        visible: false
                    }
                    Image {
                        id: itemImage
                        objectName: "Image"
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: gridView.cellWidth / 2
                        height: gridView.cellHeight / 2
                        source: modelData.icon
                    }
                    Rectangle {
                        id: textSelected
                        objectName: "Rectangle"
                        width: itemText.contentWidth + 2
                        height: itemText.contentHeight
                        anchors.horizontalCenter: itemText.horizontalCenter
                        anchors.top: itemText.top
                        visible: false
                        radius: 2
                        color: "lightblue"
                    }
                    Text {
                        id: itemText
                        objectName: "Text"
                        anchors.top: itemImage.bottom
                        anchors.topMargin: 5
                        anchors.horizontalCenter: itemImage.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData.name
                        wrapMode: Text.Wrap
                        elide: Text.ElideMiddle
                        maximumLineCount: 2
                        font.pointSize: fontSize
                        color: "black"
                        Component.onCompleted: {
                            if (itemText.contentWidth > gridView.cellWidth)
                                itemText.width = gridView.cellWidth;
                        }
                    }
                    states: [
                        State {
                            name: "selected"
                            PropertyChanges { target: itemText; color: "white" }
                            PropertyChanges { target: imageSelected; visible: true }
                            PropertyChanges { target: textSelected; visible: true }
                        }
                    ]
                }
            }

            GridView {
                id: gridView
                anchors.fill: parent
                cellWidth: cellWidth
                cellHeight: cellHeight
                clip: true
                focus: true
                model: directory.files
                delegate: gridViewDelegate
                cacheBuffer: 20000
                MouseArea {
                    id: gridViewMouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    hoverEnabled: true
                    onPositionChanged: {
                        if (gridViewMouseArea.pressed && selectLayer.visible) {
                            // 显示拖动鼠标时的线框
                            if (mouseX >= selectLayer.newX)
                                selectLayer.width = mouseX - selectLayer.x;
                            else {
                                selectLayer.x = mouseX;
                                selectLayer.width = selectLayer.newX - selectLayer.x;
                            }
                            if (mouseY >= selectLayer.newY)
                                selectLayer.height = mouseY - selectLayer.y;
                            else {
                                selectLayer.y = mouseY;
                                selectLayer.height = selectLayer.newY - selectLayer.y;
                            }
                            // 判断item是否与鼠标拖拽的线框相交
                            // 需要分别判断item中的Image和Text两个子对象是否与线框相交
                            for (var entry = 0; entry < gridView.contentItem.children.length; ++entry) {
                                var item = gridView.contentItem.children[entry];
                                if (item.objectName != "cell")
                                    continue;
                                var itemImage;
                                var itemText;
                                for (var i = 0; i < item.children.length; ++i) {
                                    if (item.children[i].objectName == "Image")
                                        itemImage = item.children[i];
                                    if (item.children[i].objectName == "Text")
                                        itemText = item.children[i];
                                }
                                var pointImage = mapFromItem(item, itemImage.x, itemImage.y);
                                var pointText = mapFromItem(item, itemText.x, itemText.y);
                                var minX = pointImage.x < pointText.x ? pointImage.x : pointText.x;
                                var maxX = pointImage.x + itemImage.width > pointText.x + itemText.width
                                        ? pointImage.x + itemImage.width : pointText.x + itemText.width;
                                var maxY = pointText.y + itemText.height - gridView.contentY;
                                var minY = pointImage.y - gridView.contentY;

                                if (maxX < selectLayer.x
                                        || minX > selectLayer.x + selectLayer.width
                                        || maxY < selectLayer.y
                                        || minY > selectLayer.y + selectLayer.height)
                                    item.state = "";
                                else {
                                    console.debug(pointText.y, itemText.height, gridView.contentY, selectLayer.y);
                                    item.state = "selected";
                                }
                            }
                        }
                    }

                    onClicked: {
                        // 在鼠标按下时会触发pressed消息，而鼠标抬起时会触发clicked和released消息
                        if (selectLayer.newX == mouseX && selectLayer.newY == mouseY) {
                            for (var entry = 0; entry < gridView.contentItem.children.length; ++entry) {
                                var item = gridView.contentItem.children[entry];
                                if (item.objectName != "cell")
                                    continue;
                                var mousePos = mapToItem(item, mouseX, mouseY);
                                item.state = "";
                                if (item.contains(mousePos)) {
                                    // 判断是否点击图片或者是文字
                                    var childItem = item.childAt(mousePos.x, mousePos.y);
                                    if (childItem && childItem.objectName != "Rectangle")
                                        item.state = "selected";
                                }
                            }
                        }
                    }

                    onDoubleClicked: {
                        for (var entry = 0; entry < gridView.contentItem.children.length; ++entry) {
                            var item = gridView.contentItem.children[entry];
                            if (item.objectName != "cell")
                                continue;
                            if (item.contains(mapToItem(item, mouseX, mouseY)))
                                directory.changeDir(directory.dir() + "/" + item.name);
                        }
                    }

                    onPressed: {
                        gridView.interactive = false;

                        selectLayer.visible = true;
                        selectLayer.x = mouseX;
                        selectLayer.y = mouseY;
                        selectLayer.newX = mouseX;
                        selectLayer.newY = mouseY;
                        selectLayer.width = 0;
                        selectLayer.height = 0;
                    }
                    onReleased: {
                        gridView.interactive = true;
                        selectLayer.visible = false;
                    }
                }

                Rectangle {
                    id: selectLayer
                    property real newX: 0
                    property real newY: 0
                    height: 0
                    width: 0
                    x: 0
                    y: 0
                    visible: false
                    color: "lightblue"
                    opacity: 0.5
                }

//                DropArea {
//                    id: gridViewDropArea
//                    anchors.fill: parent

//                    onEntered: {
//                        drag.accepted = true;
//                        console.debug("onEntered, formats - ", drag.formats, " action - ", drag.action);
//                    }
//                }
            }
        }
    }

    /*
    statusBar: StatusBar {
        id: statusBar
        style: StatusBarStyle {
            Rectangle { color: Qt.rgba(backgroundColorOfWholeAppRed, backgroundColorOfWholeAppGreen, backgroundColorOfWholeAppBlue, 1) }
        }
        height: 60
        Text {
            anchors.fill: parent
            text: gridView.currentIndex == -1 ? "" : directory.dir() + "/" + directory.files[gridView.currentIndex].wholeName
        }
    }
*/
}
