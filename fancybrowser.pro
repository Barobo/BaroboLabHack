QT      +=  webkitwidgets network widgets
HEADERS =   mainwindow.h \
            jsinterface.h \
            robotlistener.h
SOURCES =   main.cpp \
            mainwindow.cpp \
            jsinterface.cpp \
            robotlistener.cpp
RESOURCES = jquery.qrc

INCLUDEPATH += ../libbarobo/include

LIBS += -Lbuild -lbarobo

QMAKE_CXXFLAGS += -std=c++11
CONFIG += c++11

macx:LIBS += -framework IOKIT -framework CoreFoundation

win32:LIBS += -lws2_32 -lsetupapi

# install
target.path = $$[QT_INSTALL_EXAMPLES]/webkitwidgets/fancybrowser
INSTALLS += target
