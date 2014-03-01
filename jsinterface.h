//
//  jsinterface.h
//  fancybrowser
//
//  Created by Adam Ruggles on 11/23/13.
//
//

#ifndef fancybrowser_jsinterface_h
#define fancybrowser_jsinterface_h

#include "qtbugworkaround.h"
#include <QtWidgets>

class MainWindow;

class JsInterface : public QObject
{
    Q_OBJECT

public:
    JsInterface (MainWindow* mainWindow);

    Q_INVOKABLE void printDbg();
    Q_INVOKABLE QString printMessage(const QString &param);
    Q_INVOKABLE QString getRobotIDList ();
    Q_INVOKABLE bool connectRobot (const QString& address);
    Q_INVOKABLE bool connectRobot_noCB (const QString& address);
    Q_INVOKABLE void disconnectRobot (const QString& address);
    Q_INVOKABLE void disconnectRobot_noCB (const QString& address);
    Q_INVOKABLE int move (const QString& address, double angle1, double angle2, double angle3, double angle4);
    Q_INVOKABLE int moveNB (const QString& address, double angle1, double angle2, double angle3, double angle4);
    Q_INVOKABLE int moveTo (const QString& address, double angle1, double angle2, double angle3, double angle4);
    Q_INVOKABLE int moveToNB (const QString& address, double angle1, double angle2, double angle3, double angle4);
    Q_INVOKABLE QString getJointAngles (const QString& address);
    Q_INVOKABLE int setJointSpeeds (const QString& address, double speeds1, double speeds2, double speeds3, double speeds4);
    Q_INVOKABLE int setColorRGB (const QString& address, int r, int g, int b);
    Q_INVOKABLE int stop (const QString& address);

    void robotButtonCallbackWrapper(const char* serialID, int button, int buttondown);
    static void robotButtonCallback(void* data, int button, int buttondown);

public slots:
    void scrollUpSlot(QString robot);
    void scrollDownSlot(QString robot);

signals:
    void buttonChanged(QString robot, int button, int event);
    void scrollUp(QString robot);
    void scrollDown(QString robot);

private:
    MainWindow* m_mainWindow;
};
#endif
