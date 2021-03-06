import QtQuick 2.9
import QtQuick.Layouts 1.2

import co.aixon.docbrowser 1.0
import "match.js" as MatchJs
import "util.js" as UtilJs

Rectangle {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: mainItem.height
    radius: height / 10.526

    signal clicked()

    // About focus and isSelected
    //
    // matchContainerFocusScope won't always have focus, when it doesn't,
    // neither does this item. We still want a visual effect on
    // matchContainer.selected-th match, even it doesn't have focus, thus
    // the visual effect should be derived from isSelected, not from focus
    //
    // We also maintain the focus status, for the purpose of opening the
    // selected match and navigating matches.

    property bool isSelected
    focus: isSelected
    color: isSelected ? Style.selectedBg : Style.normalBg

    property bool isHoogle: modelData.vendor === "Hoogle"

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Return) {
            root.clicked();
            event.accepted = true;
        }
    }

    Item {
        id: mainItem
        anchors.fill: parent
        anchors.leftMargin: Style.ewPadding
        anchors.rightMargin: Style.ewPadding

        height: Math.max(shortcut.height,
                         icon.height,
                         mainColumn.height
                        ) + 16

        Text {
            id: shortcut
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: MatchJs.shortcutText(index)
            font: Style.matchShortcutFont
            color: root.isSelected ? Style.selectedFg : MatchJs.shortcutColor(index)
        }

        Image {
            id: icon
            anchors.left: shortcut.right
            anchors.leftMargin: Style.ewPadding
            anchors.verticalCenter: parent.verticalCenter
            source: MatchJs.icon(modelData.vendor, modelData.icon)
        }

        Column {
            id: mainColumn

            anchors.left: icon.right
            anchors.leftMargin: Style.ewPadding
            anchors.right: isHoogle ? parent.right : versionInfo.left
            anchors.rightMargin: isHoogle ? 0 : Style.ewPadding
            anchors.verticalCenter: parent.verticalCenter
            clip: true

            spacing: 4

            Text {
                text: modelData.name
                font: isHoogle ? Style.matchMainFontHoogle : Style.matchMainFont
                color: root.isSelected ? Style.selectedFg : Style.normalFg
            }

            Text {
                visible: UtilJs.isString(modelData.typeConstraint)
                text: modelData.typeConstraint
                font: Style.matchMetaFont
                color: root.isSelected ? Style.selectedFg : Style.lightFg
            }

            RowLayout {
                Text {
                    visible: UtilJs.isString(modelData.package_)
                    text: modelData.package_
                    font: Style.matchMetaFont
                    color: root.isSelected ? Style.selectedFg : Style.lightFg
                }
                Text {
                    visible: UtilJs.isString(modelData.module_)
                    anchors.leftMargin: 3
                    text: modelData.module_
                    font: Style.matchMetaFont
                    color: root.isSelected ? Style.selectedFg : Style.lightFg
                }
                Text {
                    visible: isHoogle && modelData.version !== ""
                    text: modelData.version
                    font: Style.matchMetaFont
                    color: root.isSelected ? Style.selectedFg : Style.lightFg
                }
                Text {
                    visible: isHoogle
                    anchors.leftMargin: 3
                    text: modelData.collection
                    font: Style.matchMetaFont
                    color: root.isSelected ? Style.selectedFg : Style.lightFg
                }
            }
        }

        Text {
            id: versionInfo
            visible: !isHoogle
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.version
            font: Style.matchVersionFont
            color: root.isSelected ? Style.selectedFg : Style.lightFg
        }

    }
}
