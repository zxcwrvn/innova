#ifndef BITCOINGUI_H
#define BITCOINGUI_H

#include <QMainWindow>
#include <QSystemTrayIcon>
#include <QLabel>
#include <stdint.h>

class TransactionTableModel;
class ClientModel;
class WalletModel;
class MessageModel;
class TransactionView;
class MintingView;
class ManageNamesPage;
class CollateralnodeManager;
class MultisigDialog;
class OverviewPage;
class AddressBookPage;
class MessagePage;
class StatisticsPage;
class MarketBrowser;
class BlockBrowser;
class SendCoinsDialog;
class SignVerifyMessageDialog;
class Notificator;
class RPCConsole;
class ProofOfImage;
class Hyperfile;

QT_BEGIN_NAMESPACE
class QLabel;
class QLineEdit;
class QTableView;
class QAbstractItemModel;
class QModelIndex;
class QProgressBar;
class QStackedWidget;
class QUrl;
QT_END_NAMESPACE

class ActiveLabel : public QLabel
{
    Q_OBJECT
public:
    ActiveLabel(const QString & text = "", QWidget * parent = 0);
    ~ActiveLabel(){}

signals:
    void clicked();

protected:
    void mouseReleaseEvent (QMouseEvent * event) ;

};

/**
  Bitcoin GUI main class. This class represents the main window of the Bitcoin UI. It communicates with both the client and
  wallet models to give the user an up-to-date view of the current core state.
*/
class BitcoinGUI : public QMainWindow
{
    Q_OBJECT
public:
    explicit BitcoinGUI(QWidget *parent = 0);
    ~BitcoinGUI();

    /** Set the client model.
        The client model represents the part of the core that communicates with the P2P network, and is wallet-agnostic.
    */
    void setClientModel(ClientModel *clientModel);
    /** Set the wallet model.
        The wallet model represents a bitcoin wallet, and offers access to the list of transactions, address book and sending
        functionality.
    */
    void setWalletModel(WalletModel *walletModel);
    /** Set the message model.
        The message model represents encryption message database, and offers access to the list of messages, address book and sending
        functionality.
    */
    void setMessageModel(MessageModel *messageModel);
    void checkTOU();

protected:
    void changeEvent(QEvent *e);
    void closeEvent(QCloseEvent *event);
    void dragEnterEvent(QDragEnterEvent *event);
    void dropEvent(QDropEvent *event);

private:
    ClientModel *clientModel;
    WalletModel *walletModel;
    MessageModel *messageModel;

    QStackedWidget *centralWidget;

    OverviewPage *overviewPage;
	  StatisticsPage *statisticsPage;
	  BlockBrowser *blockBrowser;
    ManageNamesPage *manageNamesPage;
	  MarketBrowser *marketBrowser;
    QWidget *transactionsPage;
	  QWidget *mintingPage;
	  MultisigDialog *multisigPage;
	  ProofOfImage *proofOfImagePage;
//    Hyperfile *hyperfilePage;
	  CollateralnodeManager *collateralnodeManagerPage;
    AddressBookPage *addressBookPage;
    AddressBookPage *receiveCoinsPage;
    MessagePage *messagePage;
    SendCoinsDialog *sendCoinsPage;
    SignVerifyMessageDialog *signVerifyMessageDialog;

    ActiveLabel *labelEncryptionIcon;
    QLabel *labelStakingIcon;
    QLabel *labelConnectionsIcon;
    QLabel *labelBlocksIcon;
    QLabel *labelConnectTypeIcon;
    QLabel *labelCNLockIcon;
    QLabel *progressBarLabel;
    QLabel *mainIcon;
    QToolBar *mainToolbar;
    QToolBar *secondaryToolbar;
    QProgressBar *progressBar;

    QMenuBar *appMenuBar;
    QAction *overviewAction;
	  QAction *statisticsAction;
	  QAction *blockAction;
	  QAction *marketAction;
    QAction *historyAction;
	  QAction *mintingAction;
	  QAction *multisigAction;
    QAction *proofOfImageAction;
    QAction *hyperfileAction;
    QAction *manageNamesAction;
	  QAction *collateralnodeManagerAction;
    QAction *quitAction;
    QAction *sendCoinsAction;
    QAction *addressBookAction;
    QAction *messageAction;
    QAction *signMessageAction;
    QAction *verifyMessageAction;
    QAction *aboutAction;
    QAction *receiveCoinsAction;
    QAction *optionsAction;
    QAction *toggleHideAction;
    QAction *exportAction;
    QAction *encryptWalletAction;
    QAction *backupWalletAction;
    QAction *changePassphraseAction;
    QAction *unlockWalletAction;
    QAction *lockWalletAction;
    QAction *aboutQtAction;
    QAction *openRPCConsoleAction;

	  QAction *openInfoAction;
    QAction *openGraphAction;
    QAction *openPeerAction;
    QAction *openConfEditorAction;
    QAction *openMNConfEditorAction;

    QSystemTrayIcon *trayIcon;
    Notificator *notificator;
    TransactionView *transactionView;
	  MintingView *mintingView;
    RPCConsole *rpcConsole;

    QMovie *syncIconMovie;

    uint64_t nWeight;
    int prevBlocks;
    int spinnerFrame;

    int64_t nClientUpdateTime;
    int64_t nLastUpdateTime;
    int nBlocksInLastPeriod;
    int nLastBlocks;
    int nBlocksPerSec;

    /** Create the main UI actions. */
    void createActions();
    /** Create the menu bar and sub-menus. */
    void createMenuBar();
    /** Create the toolbars */
    void createToolBars();
    /** Create system tray (notification) icon */
    void createTrayIcon();

public slots:
    /** Set number of connections shown in the UI */
    void setNumConnections(int count);
    /** Set number of blocks shown in the UI */
    void setNumBlocks(int count, int nTotalBlocks);
    /** Set the encryption status as shown in the UI.
       @param[in] status            current encryption status
       @see WalletModel::EncryptionStatus
    */
    void setEncryptionStatus(int status);

    /** Notify the user of an error in the network or transaction handling code. */
    void error(const QString &title, const QString &message, bool modal);
    /** Asks the user whether to pay the transaction fee or to cancel the transaction.
       It is currently not possible to pass a return value to another thread through
       BlockingQueuedConnection, so an indirected pointer is used.
       https://bugreports.qt-project.org/browse/QTBUG-10440

      @param[in] nFeeRequired       the required fee
      @param[out] payFee            true to pay the fee, false to not pay the fee
    */
    void askFee(qint64 nFeeRequired, bool *payFee);
    void handleURI(QString strURI);

    void mainToolbarOrientation(Qt::Orientation orientation);
    void secondaryToolbarOrientation(Qt::Orientation orientation);

	void gotoMultisigPage();

private slots:
    /** Switch to overview (home) page */
    void gotoOverviewPage();
	/** Switch to Statistics page */
	void gotoStatisticsPage();
	/** Switch to block explorer*/
    void gotoBlockBrowser();
	/** Switch to market*/
    void gotoMarketBrowser();
  /** Switch to manage names page */
    void gotoManageNamesPage();
	/** Switch to minting page */
    void gotoMintingPage();
    /** Switch to history (transactions) page */
    void gotoHistoryPage();
    /** Switch to address book page */
    void gotoAddressBookPage();
    /** Switch to receive coins page */
    void gotoReceiveCoinsPage();
    /** Switch to send coins page */
    void gotoSendCoinsPage();
    /** Switch to message page */
    void gotoMessagePage();
	/** Switch to collateralnode manager page */
	void gotoCollateralnodeManagerPage();
	/** Switch to proof of image page */
	void gotoProofOfImagePage();
  /** Switch to Hyperfile page */
//  void gotoHyperfilePage();


    //void gotoChatPage();

    /** Show Sign/Verify Message dialog and switch to sign message tab */
    void gotoSignMessageTab(QString addr = "");
    /** Show Sign/Verify Message dialog and switch to verify message tab */
    void gotoVerifyMessageTab(QString addr = "");

    /** Show debug window */
    void showDebugWindow();

	/** Show debug window and set focus to the appropriate tab */
    void showInfo();
    void showConsole();
    void showGraph();
    void showPeer();

    /** Open external (default) editor with innova.conf */
    void showConfEditor();
    /** Open external (default) editor with collateralnode.conf */
    void showMNConfEditor();

    /** Show configuration dialog */
    void optionsClicked();
    /** Show about dialog */
    void aboutClicked();
#ifndef Q_OS_MAC
    /** Handle tray icon clicked */
    void trayIconActivated(QSystemTrayIcon::ActivationReason reason);
#endif
    /** Show incoming transaction notification for new transactions.

        The new items are those between start and end inclusive, under the given parent item.
    */
    void incomingTransaction(const QModelIndex & parent, int start, int end);

    /** Show incoming message notification for new messages.

        The new items are those between start and end inclusive, under the given parent item.
    */
    void incomingMessage(const QModelIndex & parent, int start, int end);

    /** Encrypt the wallet */
    void encryptWallet(bool status);
    /** Backup the wallet */
    void backupWallet();
    /** Change encrypted wallet passphrase */
    void changePassphrase();
    /** Ask for passphrase to unlock wallet temporarily */
    void unlockWallet();

    void lockWallet();

    /** Show window if hidden, unminimize when minimized, rise when obscured or show if hidden and fToggleHidden is true */
    void showNormalIfMinimized(bool fToggleHidden = false);
    /** simply calls showNormalIfMinimized(true) for use in SLOT() macro */
    void toggleHidden();

    void updateWeight();
    void updateStakingIcon();
};

#endif
