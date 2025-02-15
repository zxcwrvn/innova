TEMPLATE = app
TARGET = innova
VERSION = 4.3.9.5
INCLUDEPATH += src src/json src/qt src/qt/plugins/mrichtexteditor
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE CURL_STATICLIB
CONFIG += no_include_pwd
CONFIG += thread
CONFIG += static
CONFIG += c++11
QT += core gui network widgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
lessThan(QT_MAJOR_VERSION, 5): CONFIG += static
QMAKE_CXXFLAGS += -fpermissive -Wno-literal-suffix
QMAKE_CFLAGS += -std=c99

greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets printsupport
    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
}

linux {
    QMAKE_CFLAGS += -std=gnu99
}

win32 {
BOOST_LIB_SUFFIX=-mt
BOOST_THREAD_LIB_SUFFIX=_win32-mt
BOOST_INCLUDE_PATH=C:/deps/boost_1_57_0
BOOST_LIB_PATH=C:/deps/boost_1_57_0/stage/lib
BDB_INCLUDE_PATH=C:/deps/db-4.8.30.NC/build_unix
BDB_LIB_PATH=C:/deps/db-4.8.30.NC/build_unix
OPENSSL_INCLUDE_PATH=/mnt/deps/openssl/include
OPENSSL_LIB_PATH=/mnt/deps/openssl
MINIUPNPC_INCLUDE_PATH=/mnt/deps/miniupnp
MINIUPNPC_LIB_PATH=/mnt/deps/miniupnp/miniupnpc
LIBPNG_INCLUDE_PATH=C:/deps/libpng-1.6.16
LIBPNG_LIB_PATH=C:/deps/libpng-1.6.16/.libs
QRENCODE_INCLUDE_PATH=C:/deps/qrencode-3.4.4
QRENCODE_LIB_PATH=C:/deps/qrencode-3.4.4/.libs
LIBEVENT_INCLUDE_PATH=C:/deps/libevent/include
LIBEVENT_LIB_PATH=C:/deps/libevent/.libs
LIBCURL_INCLUDE_PATH=C:/deps/libcurl/include
LIBCURL_LIB_PATH=C:/deps/libcurl/lib
}

# for boost 1.37, add -mt to the boost libraries
# use: qmake BOOST_LIB_SUFFIX=-mt
# for boost thread win32 with _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX=_win32-...
# or when linking against a specific BerkelyDB version: BDB_LIB_SUFFIX=-4.8

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE=1"
contains(RELEASE, 1) {
    # Mac: compile for maximum compatibility (10.6, 32-bit)
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=11 -arch x86_64 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/



    !windows:!macx {
        # Linux: static link
        LIBS += -Wl,-Bstatic
    }
}

!win32 {
# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
QMAKE_CXXFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
QMAKE_LFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
# We need to exclude this for Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
# This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}
# for extra security on Windows: enable ASLR and DEP via GCC linker flags
# win32:QMAKE_LFLAGS *= -Wl,--large-address-aware -static
win32:QMAKE_LFLAGS *= -static
#win32:QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat
#win32:QMAKE_LFLAGS += -static-libgcc -static-libstdc++
lessThan(QT_MAJOR_VERSION, 5): win32: QMAKE_LFLAGS *= -static

# use: qmake "USE_IPFS=1" ( enabled by default; default)
#  or: qmake "USE_IPFS=0" (disabled by default)
#  or: qmake "USE_IPFS=-" (not supported)
# I n n o v a IPFS - USE_IPFS=- to not compile with the IPFS C Library located in src/ipfs
contains(USE_IPFS, -) {
    message(Building without IPFS support)
} else {
    message(Building with IPFS support)
    count(USE_IPFS, 0) {
        USE_IPFS=1
    }
    DEFINES += USE_IPFS=$$USE_IPFS
    INCLUDEPATH += src/ipfs

	###IPFS C Library native integration sources
	SOURCES += src/ipfs.cc \
		src/ipfscurl.cc
}


# use: qmake "USE_NATIVETOR=1" ( enabled by default; default)
#  or: qmake "USE_NATIVETOR=0" (disabled by default)
#  or: qmake "USE_NATIVETOR=-" (not supported)
# I n n o v a Native Tor - USE_NATIVETOR=- to not compile with the Tor C Library by Tor Project located in src/tor OpenSSL 1.1 Compat not available with Native Tor
contains(USE_NATIVETOR, -) {
    message(Building without Native Tor support)
} else {
    message(Building with Native Tor support)
    count(USE_NATIVETOR, 0) {
        USE_NATIVETOR=1
    }
    DEFINES += USE_NATIVETOR=$$USE_NATIVETOR
    INCLUDEPATH += src/tor

	### Tor native integration sources
	SOURCES += src/tor/anonymize.cpp \
		src/tor/address.c \
		src/tor/addressmap.c \
		src/tor/aes.c \
		src/tor/backtrace.c \
		src/tor/blinding.c \
		src/tor/bridges.c \
		src/tor/buffers.c \
		src/tor/cell_common.c \
		src/tor/cell_establish_intro.c \
		src/tor/cell_introduce1.c \
		src/tor/channel.c \
		src/tor/channeltls.c \
		src/tor/circpathbias.c \
		src/tor/circuitbuild.c \
		src/tor/circuitlist.c \
		src/tor/circuitmux.c \
		src/tor/circuitmux_ewma.c \
		src/tor/circuitstats.c \
		src/tor/circuituse.c \
		src/tor/command.c \
		src/tor/compat_libevent.c \
		src/tor/compat_threads.c \
		src/tor/compat_time.c \
		src/tor/config.c \
		src/tor/confparse.c \
		src/tor/connection.c \
		src/tor/connection_edge.c \
		src/tor/connection_or.c \
		src/tor/container.c \
		src/tor/control.c \
		src/tor/crypto.c \
		src/tor/crypto_curve25519.c \
		src/tor/crypto_ed25519.c \
		src/tor/crypto_format.c \
		src/tor/crypto_pwbox.c \
		src/tor/crypto_s2k.c \
		src/tor/cpuworker.c \
		src/tor/csiphash.c \
		src/tor/curve25519-donna.c \
		src/tor/di_ops.c \
		src/tor/dircollate.c \
		src/tor/directory.c \
		src/tor/dirserv.c \
		src/tor/dirvote.c \
		src/tor/dns.c \
		src/tor/dnsserv.c \
		src/tor/ed25519_cert.c \
		src/tor/ed25519_tor.c \
		src/tor/entrynodes.c \
		src/tor/ext_orport.c \
		src/tor/fe_copy.c \
		src/tor/fe_cmov.c \
		src/tor/fe_isnegative.c \
		src/tor/fe_sq.c \
		src/tor/fe_pow22523.c \
		src/tor/fe_isnonzero.c \
		src/tor/fe_neg.c \
		src/tor/fe_frombytes.c \
		src/tor/fe_invert.c \
		src/tor/fe_sub.c \
		src/tor/fe_add.c \
		src/tor/fe_1.c \
		src/tor/fe_mul.c \
		src/tor/fe_tobytes.c \
		src/tor/fe_0.c \
		src/tor/fe_sq2.c \
		src/tor/fp_pair.c \
		src/tor/ge_scalarmult_base.c \
		src/tor/ge_p3_tobytes.c \
		src/tor/ge_frombytes.c \
		src/tor/ge_double_scalarmult.c \
		src/tor/ge_tobytes.c \
		src/tor/ge_p3_to_cached.c \
		src/tor/ge_p3_to_p2.c \
		src/tor/ge_p3_dbl.c \
		src/tor/ge_p3_0.c \
		src/tor/ge_p1p1_to_p2.c \
		src/tor/ge_p1p1_to_p3.c \
		src/tor/ge_add.c \
		src/tor/ge_p2_0.c \
		src/tor/ge_p2_dbl.c \
		src/tor/ge_madd.c \
		src/tor/ge_msub.c \
		src/tor/ge_sub.c \
		src/tor/ge_precomp_0.c \
		src/tor/geoip.c \
		src/tor/hibernate.c \
		src/tor/hs_cache.c \
		src/tor/hs_circuitmap.c \
		src/tor/hs_common.c \
		src/tor/hs_descriptor.c \
		src/tor/hs_intropoint.c \
		src/tor/hs_service.c \
		src/tor/keyconv.c \
		src/tor/keypair.c \
		src/tor/keypin.c \
		src/tor/keccak-tiny-unrolled.c \
		src/tor/link_handshake.c \
		src/tor/log.c \
		src/tor/tormain.c \
		src/tor/memarea.c \
		src/tor/microdesc.c \
		src/tor/networkstatus.c \
		src/tor/nodelist.c \
		src/tor/ntmain.c \
		src/tor/onion.c \
		src/tor/onion_fast.c \
		src/tor/onion_ntor.c \
		src/tor/onion_tap.c \
		src/tor/open.c \
		src/tor/parsecommon.c \
		src/tor/periodic.c \
		src/tor/policies.c \
		src/tor/procmon.c \
		src/tor/protover.c \
		src/tor/pwbox.c \
		src/tor/reasons.c \
		src/tor/relay.c \
		src/tor/rendcache.c \
		src/tor/rendclient.c \
		src/tor/rendcommon.c \
		src/tor/rendmid.c \
		src/tor/rendservice.c \
		src/tor/rephist.c \
		src/tor/replaycache.c \
		src/tor/router.c \
		src/tor/routerkeys.c \
		src/tor/routerlist.c \
		src/tor/routerparse.c \
		src/tor/routerset.c \
		src/tor/sandbox.c \
		src/tor/sc_reduce.c \
		src/tor/sc_muladd.c \
		src/tor/scheduler.c \
		src/tor/shared_random.c \
		src/tor/shared_random_state.c \
		src/tor/sign.c \
		src/tor/statefile.c \
		src/tor/status.c \
		src/tor/torcert.c \
		src/tor/torcompat.c \
		src/tor/tor_main.c \
		src/tor/torgzip.c \
		src/tor/tortls.c \
		src/tor/torutil.c \
		src/tor/transports.c \
		src/tor/trunnel.c \
		src/tor/util_bug.c \
		src/tor/util_format.c \
		src/tor/util_process.c \
		src/tor/workqueue.c \

	win32 {
		SOURCES += src/tor/compat_winthreads.c
	} else {
		SOURCES += src/tor/compat_pthreads.c \
			src/tor/readpassphrase.c
	}
}

# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    LIBS += -lqrencode
}
contains(USE_PROFILER, 1) {
    QMAKE_LFLAGS += -pg
    QMAKE_CXXFLAGS += -pg
}

contains(USE_DEBUG_FLAGS, 1) {
    QMAKE_LFLAGS += -Og
    QMAKE_CXXFLAGS += -Og
}

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP MINIUPNP_STATICLIB
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    win32:LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1" or qmake "USE_DBUS=0"
linux:count(USE_DBUS, 0) {
    USE_DBUS=1
}
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

# use: qmake "USE_LEVELDB=1" ( enabled by default; default)
#  or: qmake "USE_LEVELDB=0" (disabled by default)
#  or: qmake "USE_LEVELDB=-" (not supported)
contains(USE_LEVELDB, -) {
	message(Building with Berkeley DB transaction index)

	    SOURCES += src/txdb-bdb.cpp \
		src/hash.cpp \
		src/aes_helper.c \
		src/echo.c \
		src/jh.c \
		src/keccak.c

} else {
	message(Building with LevelDB transaction index)
	count(USE_LEVELDB, 0) {
        USE_LEVELDB=1
    }

	DEFINES += USE_LEVELDB

    INCLUDEPATH += src/leveldb/include src/leveldb/helpers
	LIBS += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a
	SOURCES += src/txdb-leveldb.cpp \
		src/hash.cpp \
		src/aes_helper.c \
		src/echo.c \
		src/jh.c \
		src/keccak.c
	!win32 {
		# we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
		genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
	} else {
		# make an educated guess about what the ranlib command is called
		isEmpty(QMAKE_RANLIB) {
			QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
		}
		LIBS += -lshlwapi
		#genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libmemenv.a
	}
	genleveldb.target = $$PWD/src/leveldb/libleveldb.a
	genleveldb.depends = FORCE
	PRE_TARGETDEPS += $$PWD/src/leveldb/libleveldb.a
	QMAKE_EXTRA_TARGETS += genleveldb
	# Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
	QMAKE_CLEAN += $$PWD/src/leveldb/libleveldb.a; cd $$PWD/src/leveldb ; $(MAKE) clean

}

# regenerate src/build.h
!windows|contains(USE_BUILD_INFO, 1) {
    genbuild.depends = FORCE
    genbuild.commands = cd $$PWD; /bin/sh share/genbuild.sh $$OUT_PWD/build/build.h
    genbuild.target = $$OUT_PWD/build/build.h
    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
    QMAKE_EXTRA_TARGETS += genbuild
    DEFINES += HAVE_BUILD_INFO
}

contains(USE_O3, 1) {
    message(Building O3 optimization flag)
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS += -O3
    QMAKE_CFLAGS += -O3
}

*-g++-32 {
    message("32 platform, adding -msse2 flag")

    QMAKE_CXXFLAGS += -msse2
    QMAKE_CFLAGS += -msse2
}

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wno-format -Wno-unused-parameter -Wstack-protector


# Input
DEPENDPATH += src src/json src/qt
HEADERS += src/qt/bitcoingui.h \
    src/qt/intro.h \
    src/qt/transactiontablemodel.h \
    src/qt/addresstablemodel.h \
    src/qt/peertablemodel.h \
    src/qt/optionsdialog.h \
    src/qt/coincontroldialog.h \
    src/qt/coincontroltreewidget.h \
    src/qt/sendcoinsdialog.h \
    src/qt/addressbookpage.h \
    src/qt/signverifymessagedialog.h \
    src/qt/aboutdialog.h \
    src/qt/editaddressdialog.h \
    src/qt/bitcoinaddressvalidator.h \
    src/kernelrecord.h \
    src/qt/mintingfilterproxy.h \
    src/qt/mintingtablemodel.h \
    src/qt/mintingview.h \
    src/qt/proofofimage.h \
#    src/qt/hyperfile.h \
    src/qt/multisigaddressentry.h \
    src/qt/multisiginputentry.h \
    src/qt/multisigdialog.h \
    src/qt/bantablemodel.h \
    src/alert.h \
    src/addrman.h \
    src/base58.h \
    src/bignum.h \
    src/checkpoints.h \
    src/compat.h \
    src/coincontrol.h \
    src/sync.h \
    src/tinyformat.h \
    src/util.h \
    src/uint256.h \
    src/kernel.h \
    src/scrypt.h \
    src/pbkdf2.h \
    src/serialize.h \
    src/strlcpy.h \
    src/smessage.h \
    src/main.h \
    src/core.h \
    src/state.h \
    src/ringsig.h \
    src/miner.h \
    src/net.h \
    src/key.h \
    src/db.h \
    src/txdb.h \
    src/walletdb.h \
    src/script.h \
    src/stealth.h \
    src/idns.h \
    src/hooks.h \
    src/namecoin.h \
    src/collateral.h \
    src/activecollateralnode.h \
    src/collateralnode.h \
    src/collateralnodeconfig.h \
    src/spork.h \
    src/init.h \
    src/mruset.h \
    src/utiltime.h \
    src/openssl_compat.h \
    src/json/json_spirit_writer_template.h \
    src/json/json_spirit_writer.h \
    src/json/json_spirit_value.h \
    src/json/json_spirit_utils.h \
    src/json/json_spirit_stream_reader.h \
    src/json/json_spirit_reader_template.h \
    src/json/json_spirit_reader.h \
    src/json/json_spirit_error_position.h \
    src/json/json_spirit.h \
    src/qt/clientmodel.h \
    src/qt/guiutil.h \
    src/qt/transactionrecord.h \
    src/qt/guiconstants.h \
    src/qt/optionsmodel.h \
    src/qt/monitoreddatamapper.h \
    src/qt/transactiondesc.h \
    src/qt/transactiondescdialog.h \
    src/qt/bitcoinamountfield.h \
    src/wallet.h \
    src/keystore.h \
    src/qt/transactionfilterproxy.h \
    src/qt/transactionview.h \
    src/qt/walletmodel.h \
    src/innovarpc.h \
    src/qt/overviewpage.h \
    src/qt/csvmodelwriter.h \
    src/crypter.h \
    src/qt/sendcoinsentry.h \
    src/qt/qvalidatedlineedit.h \
    src/qt/bitcoinunits.h \
    src/qt/qvaluecombobox.h \
    src/qt/askpassphrasedialog.h \
    src/protocol.h \
    src/qt/notificator.h \
    src/qt/qtipcserver.h \
    src/allocators.h \
    src/ui_interface.h \
    src/qt/rpcconsole.h \
    src/qt/trafficgraphwidget.h \
    src/qt/blockbrowser.h \
    src/qt/statisticspage.h \
    src/qt/marketbrowser.h \
    src/qt/qcustomplot.h \
    src/qt/collateralnodemanager.h \
    src/qt/addeditadrenalinenode.h \
    src/qt/adrenalinenodeconfigdialog.h \
    src/qt/termsofuse.h \
    src/version.h \
    src/bloom.h \
    src/netbase.h \
    src/clientversion.h \
    src/hash.h \
    src/hashblock.h \
    src/sph_echo.h \
    src/sph_keccak.h \
    src/sph_jh.h \
    src/sph_types.h \
    src/threadsafety.h \
    src/eccryptoverify.h \
    src/qt/nametablemodel.h \
    src/qt/managenamespage.h \
    src/qt/messagepage.h \
    src/qt/messagemodel.h \
    src/qt/sendmessagesdialog.h \
    src/qt/sendmessagesentry.h \
    src/qt/plugins/mrichtexteditor/mrichtextedit.h \
    src/qt/qvalidatedtextedit.h

SOURCES += src/qt/bitcoin.cpp src/qt/bitcoingui.cpp \
    src/qt/intro.cpp \
    src/qt/transactiontablemodel.cpp \
    src/qt/addresstablemodel.cpp \
    src/qt/peertablemodel.cpp \
    src/qt/optionsdialog.cpp \
    src/qt/sendcoinsdialog.cpp \
    src/qt/coincontroldialog.cpp \
    src/qt/coincontroltreewidget.cpp \
    src/qt/addressbookpage.cpp \
    src/qt/signverifymessagedialog.cpp \
    src/qt/aboutdialog.cpp \
    src/qt/editaddressdialog.cpp \
    src/qt/bitcoinaddressvalidator.cpp \
    src/qt/statisticspage.cpp \
    src/qt/blockbrowser.cpp \
    src/qt/marketbrowser.cpp \
    src/kernelrecord.cpp \
    src/qt/mintingfilterproxy.cpp \
    src/qt/mintingtablemodel.cpp \
    src/qt/mintingview.cpp \
    src/qt/multisigaddressentry.cpp \
    src/qt/multisiginputentry.cpp \
    src/qt/multisigdialog.cpp \
    src/qt/proofofimage.cpp \
#    src/qt/hyperfile.cpp \
    src/qt/termsofuse.cpp \
    src/qt/bantablemodel.cpp \
    src/alert.cpp \
    src/stun.cpp \
    src/base58.cpp \
    src/version.cpp \
    src/sync.cpp \
    src/smessage.cpp \
    src/util.cpp \
    src/netbase.cpp \
    src/key.cpp \
    src/script.cpp \
    src/main.cpp \
    src/core.cpp \
    src/bloom.cpp \
    src/state.cpp \
    src/ringsig.cpp \
    src/miner.cpp \
    src/init.cpp \
    src/net.cpp \
    src/checkpoints.cpp \
    src/addrman.cpp \
    src/db.cpp \
    src/utiltime.cpp \
    src/eccryptoverify.cpp \
    src/walletdb.cpp \
    src/qt/clientmodel.cpp \
    src/qt/guiutil.cpp \
    src/qt/transactionrecord.cpp \
    src/qt/optionsmodel.cpp \
    src/qt/monitoreddatamapper.cpp \
    src/qt/transactiondesc.cpp \
    src/qt/transactiondescdialog.cpp \
    src/qt/bitcoinstrings.cpp \
    src/qt/bitcoinamountfield.cpp \
    src/wallet.cpp \
    src/keystore.cpp \
    src/qt/transactionfilterproxy.cpp \
    src/qt/transactionview.cpp \
    src/qt/walletmodel.cpp \
    src/innovarpc.cpp \
    src/rpcdump.cpp \
    src/rpcnet.cpp \
    src/rpcmining.cpp \
    src/rpcwallet.cpp \
    src/rpccollateral.cpp \
#    src/rpchyperfile.cpp \
    src/rpcblockchain.cpp \
    src/rpcrawtransaction.cpp \
    src/rpcsmessage.cpp \
    src/qt/overviewpage.cpp \
    src/qt/csvmodelwriter.cpp \
    src/crypter.cpp \
    src/qt/sendcoinsentry.cpp \
    src/qt/qvalidatedlineedit.cpp \
    src/qt/bitcoinunits.cpp \
    src/qt/qvaluecombobox.cpp \
    src/qt/askpassphrasedialog.cpp \
    src/protocol.cpp \
    src/qt/notificator.cpp \
    src/qt/qtipcserver.cpp \
    src/qt/rpcconsole.cpp \
    src/qt/trafficgraphwidget.cpp \
    src/qt/nametablemodel.cpp \
    src/qt/managenamespage.cpp \
    src/qt/messagepage.cpp \
    src/qt/messagemodel.cpp \
    src/qt/qcustomplot.cpp \
    src/qt/sendmessagesdialog.cpp \
    src/qt/sendmessagesentry.cpp \
    src/qt/qvalidatedtextedit.cpp \
    src/qt/plugins/mrichtexteditor/mrichtextedit.cpp \
    src/qt/collateralnodemanager.cpp \
    src/qt/addeditadrenalinenode.cpp \
    src/qt/adrenalinenodeconfigdialog.cpp \
    src/noui.cpp \
    src/kernel.cpp \
    src/scrypt-arm.S \
    src/scrypt-x86.S \
    src/scrypt-x86_64.S \
    src/scrypt.cpp \
    src/pbkdf2.cpp \
    src/stealth.cpp \
    src/idns.cpp \
	src/namecoin.cpp \
    src/collateral.cpp \
    src/activecollateralnode.cpp \
    src/collateralnode.cpp \
    src/collateralnodeconfig.cpp \
    src/spork.cpp

#### I n n o v a sources

RESOURCES += \
    src/qt/bitcoin.qrc \
    src/qt/res/themes/qdarkstyle/style.qrc

FORMS += \
    src/qt/forms/intro.ui \
    src/qt/forms/coincontroldialog.ui \
    src/qt/forms/sendcoinsdialog.ui \
    src/qt/forms/addressbookpage.ui \
    src/qt/forms/signverifymessagedialog.ui \
    src/qt/forms/aboutdialog.ui \
    src/qt/forms/editaddressdialog.ui \
    src/qt/forms/transactiondescdialog.ui \
    src/qt/forms/overviewpage.ui \
    src/qt/forms/sendcoinsentry.ui \
    src/qt/forms/askpassphrasedialog.ui \
    src/qt/forms/rpcconsole.ui \
    src/qt/forms/optionsdialog.ui \
    src/qt/forms/messagepage.ui \
    src/qt/forms/statisticspage.ui \
    src/qt/forms/blockbrowser.ui \
    src/qt/forms/marketbrowser.ui \
    src/qt/forms/proofofimage.ui \
#    src/qt/forms/hyperfile.ui \
    src/qt/forms/termsofuse.ui \
    src/qt/forms/collateralnodemanager.ui \
    src/qt/forms/addeditadrenalinenode.ui \
    src/qt/forms/adrenalinenodeconfigdialog.ui \
    src/qt/forms/multisigaddressentry.ui \
    src/qt/forms/multisiginputentry.ui \
    src/qt/forms/multisigdialog.ui \
    src/qt/forms/managenamespage.ui \
    src/qt/forms/sendmessagesentry.ui \
    src/qt/forms/sendmessagesdialog.ui \
    src/qt/plugins/mrichtexteditor/mrichtextedit.ui

contains(USE_QRCODE, 1) {
HEADERS += src/qt/qrcodedialog.h
SOURCES += src/qt/qrcodedialog.cpp
FORMS += src/qt/forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to src/qt/bitcoin.qrc under translations/
TRANSLATIONS = $$files(src/qt/locale/bitcoin_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/src/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# "Other files" to show in Qt Creator
OTHER_FILES += \
    doc/*.rst doc/*.txt doc/README README.md res/bitcoin-qt.rc

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    macx:BOOST_LIB_SUFFIX = -mt
    windows:BOOST_LIB_SUFFIX = -mgw48-mt-s-1_55
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

isEmpty(BDB_LIB_PATH) {
    macx:BDB_LIB_PATH = /opt/local/lib/db48
}

isEmpty(BDB_LIB_SUFFIX) {
    macx:BDB_LIB_SUFFIX = -4.8
}

isEmpty(BDB_INCLUDE_PATH) {
    macx:BDB_INCLUDE_PATH = /opt/local/include/db48
}

isEmpty(BOOST_LIB_PATH) {
    macx:BOOST_LIB_PATH = /opt/local/lib
}

isEmpty(BOOST_INCLUDE_PATH) {
    macx:BOOST_INCLUDE_PATH = /opt/local/include
}

macx:OPENSSL_LIB_PATH = /opt/local/lib/openssl-1.0
macx:OPENSSL_INCLUDE_PATH = /opt/local/include/openssl-1.0


windows:DEFINES += WIN32
windows:RC_FILE = src/qt/res/bitcoin-qt.rc

windows:!contains(MINGW_THREAD_BUGFIX, 0) {
    # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
    # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
    # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
    # it is prepended to QMAKE_LIBS_QT_ENTRY.
    # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
    # any problems on some untested qmake profile now or in the future.
    DEFINES += _MT BOOST_THREAD_PROVIDES_GENERIC_SHARED_MUTEX_ON_WIN
    QMAKE_LIBS_QT_ENTRY = -lmingwthrd $$QMAKE_LIBS_QT_ENTRY
}

!windows:!macx {
    DEFINES += LINUX
    LIBS += -lrt
}

macx:HEADERS += src/qt/macdockiconhandler.h src/qt/macnotificationhandler.h
macx:OBJECTIVE_SOURCES += src/qt/macdockiconhandler.mm src/qt/macnotificationhandler.mm
macx:LIBS += -framework Foundation -framework ApplicationServices -framework AppKit
macx:DEFINES += MAC_OSX MSG_NOSIGNAL=0
macx:ICON = src/qt/res/icons/innova.icns
macx:TARGET = "Innova"
macx:QMAKE_CFLAGS_THREAD += -pthread
macx:QMAKE_LFLAGS_THREAD += -pthread
macx:QMAKE_MACOSX_DEPLOYMENT_TARGET = 11
macx:QMAKE_MAC_SDK = macosx11.1
macx:QMAKE_CXXFLAGS_THREAD += -pthread
macx:QMAKE_RPATHDIR = @executable_path/../Frameworks
macx:QMAKE_CXXFLAGS += -stdlib=libc++


# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH $$LIBEVENT_INCLUDE_PATH $$LIBCURL_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,) $$join(LIBEVENT_LIB_PATH,,-L,) $$join(LIBCURL_LIB_PATH,,-L,)
LIBS += -lcurl -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX
LIBS += -lz -levent

# -lgdi32 has to happen after -lcrypto (see  #681)
windows:LIBS += -lws2_32 -lshlwapi -lmswsock -lole32 -loleaut32 -luuid -lgdi32
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX -lboost_chrono$$BOOST_LIB_SUFFIX
windows:LIBS += -lboost_chrono$$BOOST_LIB_SUFFIX

contains(RELEASE, 1) {
    !windows:!macx {
        # Linux: turn dynamic linking back on for c/c++ runtime libraries
        LIBS += -Wl,-Bdynamic
    }
}

!windows:!macx:!android:!ios {
     DEFINES += LINUX
     LIBS += -lrt -ldl
 }

system($$QMAKE_LRELEASE -silent $$_PRO_FILE_)
