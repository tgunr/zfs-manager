//
//  SPConstants.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on October 16, 2009.
//  Copyright (c) 2009 Stuart Connolly. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/sequelpro/sequelpro>

/**
 * This header should be used to define constants that are used globally (i.e. among multiple classes/files).
 * Constants that need only be defined for a particular class should be done within the implementation file
 * of said class. Try to avoid the use of macros to define constants as much as possible as they do not incur
 * type checking when used and cannot be tested for equality.
 */
import Foundation

// View modes
enum SPViewMode : Int {
    case spStructureViewMode = 1
    case spContentViewMode = 2
    case spRelationsViewMode = 3
    case spTableInfoViewMode = 4
    case spQueryEditorViewMode = 5
    case spTriggersViewMode = 6
}

// Query modes
enum SPQueryMode : Int {
    case spInterfaceQueryMode = 0
    case spCustomQueryQueryMode = 1
    case spImportExportQueryMode = 2
}

// Connection types
enum SPConnectionType : Int {
    case sptcpipConnection = 0
    case spSocketConnection = 1
    case spsshTunnelConnection = 2
}

// Export type constants
enum SPExportType : Int {
    case spsqlExport = 0
    case spcsvExport = 1
    case spxmlExport = 2
    case spDotExport = 3
    case sppdfExport = 4
    case sphtmlExport = 5
    case spExcelExport = 6
    case spAnyExportType = -1 // this is a transient type to indicate "no specific choice"
}

// Export source constants
enum SPExportSource : Int {
    case spFilteredExport = 0
    case spQueryExport = 1
    case spTableExport = 2
}

// SQL export INSERT statment divider constants
enum SPSQLExportInsertDivider : Int {
    case spsqlInsertEveryNDataBytes = 0
    case spsqlInsertEveryNRows = 1
}

// XML export formats
enum SPXMLExportFormat : Int {
    case spxmlExportMySQLFormat = 0
    case spxmlExportPlainFormat = 1
}

// Table row count query usage levels
enum SPRowCountQueryUsageLevels : Int {
    case spRowCountFetchNever = 0
    case spRowCountFetchIfCheap = 1
    case spRowCountFetchAlways = 2
}

// Database object (table list) types
enum SPTableType : Int {
    case none = -1
    case table = 0
    case view = 1
    case proc = 2
    case `func` = 3
    case event = 4
}

// Content views
enum SPTableViewType : Int {
    case spTableViewStructure = 0
    case spTableViewContent = 1
    case spTableViewCustomQuery = 2
    case spTableViewStatus = 3
    case spTableViewRelations = 4
    case spTableViewTriggers = 5
    case spTableViewInvalid = -1
}

// SSH tunnel password modes
enum SPSSHTunnelPasswordMode : Int {
    case spsshPasswordUsesKeychain = 0
    case spsshPasswordAsksUI = 1
    case spsshPasswordNone = 2
}

// Sort by constants
enum SPFavoritesSortItem : Int {
    case spFavoritesSortUnsorted = -1
    case spFavoritesSortNameItem = 0
    case spFavoritesSortHostItem = 1
    case spFavoritesSortTypeItem = 2
    case spFavoritesSortColorItem = 3
}

// Text and link cell draw states
enum SPTextAndLinkCellDrawState : Int {
    case spLinkDrawStateNormal = 0
    case spLinkDrawStateHighlight = 1
    case spLinkDrawStateBackgroundHighlight = 2
}

// Menu tag constants
enum SPMainMenuTags : Int {
    case spMainMenuSequelPro = 0
    case spMainMenuFile = 1
    case spMainMenuFileSaveConnection = 1004
    case spMainMenuFileSaveConnectionAs = 1005
    case spMainMenuFileSaveQuery = 1006
    case spMainMenuFileSaveQueryAs = 1008
    case spMainMenuFileSaveSession = 1020
    case spMainMenuFileSaveSessionAs = 1021
    case spMainMenuFileClose = 1003
    case spMainMenuFileCloseTab = 1103
    case spMainMenuEdit = 2
    case spMainMenuView = 3
    case spMainMenuDatabase = 4
    case spMainMenuTable = 5
    case spMainMenuBundles = 6
    case spMainMenuWindow = 7
    case spMainMenuHelp = 8
}

// Encoding constants
enum SPEncodingTypes : Int {
    case spEncodingAutodetect = 0
    case spEncodingUCS2 = 10
    case spEncodingUTF8 = 20
    case spEncodingUTF8viaLatin1 = 30
    case spEncodingASCII = 40
    case spEncodingLatin1 = 50
    case spEncodingMacRoman = 60
    case spEncodingCP1250Latin2 = 70
    case spEncodingISOLatin2 = 80
    case spEncodingCP1256Arabic = 90
    case spEncodingGreek = 100
    case spEncodingHebrew = 110
    case spEncodingLatin5Turkish = 120
    case spEncodingCP1257WinBaltic = 130
    case spEncodingCP1251WinCyrillic = 140
    case spEncodingBig5Chinese = 150
    case spEncodingShiftJISJapanese = 160
    case spEncodingEUCJPJapanese = 170
    case spEncodingEUCKRKorean = 180
    case spEncodingUTF8MB4 = 190
}

// Table index type menu tags
enum SPTableIndexTypeTags : Int {
    case spPrimaryKeyMenuTag = 0
    case spIndexMenuTag = 1
    case spUniqueMenuTag = 2
    case spFullTextMenuTag = 3
    case spSpatialMenuTag = 4
}

// File compression formats
enum SPFileCompressionFormat : Int {
    case spNoCompression = 0
    case spGzipCompression = 1
    case spBzip2Compression = 2
}

// Import SQL error handling tags/choices
enum SPSQLImportErrorHandling : Int {
    case spsqlImportAskOnError = 0
    case spsqlImportIgnoreErrors = 1
}

// Export file handle creation 
enum SPExportFileHandleStatus : Int {
    case spExportFileHandleInvalid = -1
    case spExportFileHandleCreated = 0
    case spExportFileHandleFailed = 1
    case spExportFileHandleExists = 2
}

enum SPPreferenceFontChangeTarget : Int {
    case spPrefFontChangeTargetTable = 1
    case spPrefFontChangeTargetEditor = 2
}

// Predefined localisable URLs
let SPLOCALIZEDURL_HOMEPAGE = NSLocalizedString("https://www.sequelpro.com/", comment: "Localized home page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_FAQ = NSLocalizedString("https://www.sequelpro.com/docs/Frequently_Asked_Questions", comment: "Localized help page for Frequently Asked Questions - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_DOCUMENTATION = NSLocalizedString("https://www.sequelpro.com/docs/", comment: "Localized documentation home page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_CONTACT = NSLocalizedString("https://www.sequelpro.com/docs/Contact_the_developers", comment: "Localized contact page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_KEYBOARDSHORTCUTS = NSLocalizedString("https://www.sequelpro.com/docs/Keyboard_Shortcuts", comment: "Localized keyboard shortcuts page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_CONNECTIONHELP = NSLocalizedString("https://www.sequelpro.com/docs/category/getting-connected/", comment: "Localized connection help page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_TRANSLATIONFEEDBACK = NSLocalizedString("https://dev.sequelpro.com/translate/feedback", comment: "Localized translation feedback page - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_BUNDLEEDITORHELP = NSLocalizedString("https://www.sequelpro.com/bundles/reference/", comment: "Localized help page for bundle editor - do not localize if no translated webpage is available")
let SPLOCALIZEDURL_CONTENTFILTERHELP = NSLocalizedString("https://www.sequelpro.com/docs/Content_Filters", comment: "Localized help page for content filter - do not localize if no translated webpage is available")

// Narrow down completion max rows// Default monospaced font name// System database names// Table view drag types// File extensions// File names// SPF file types// Folder names// Table filter// Preference key constants// General Prefpane// Tables Prefpane// Favorites Prefpane// Notifications Prefpane// Network Prefpane// Editor Prefpane// AutoUpdate Prefpane// GUI Prefs// Hidden Prefs// Import and export// Export filename tokens// Misc// URLs// Toolbar constants
//
// Main window toolbar// Preferences toolbar// Connection favorite keys// Favorites import/export// Bundle Files and Bundle Editorenum SPBundleRedirectAction : Int {
enum SPBundleRedirectAction: Int {
    case none = 200
    case replaceSection = 201
    case replaceContent = 202
    case insertAsText = 203
    case insertAsSnippet = 204
    case showAsHTML = 205
    case showAsTextTooltip = 207
    case showAsHTMLTooltip = 208
    case lastCode = 299
}

enum SPErrorCode: Int {
// URL scheme /* generic SP error domain for NSError */enum SPErrorCode : Int {
    //* When plist deserialization fails with nil return and no NSError or the returned object has the wrong type
    case spErrorWrongTypeOrNil = 110001
    //* Parsed data is syntactically correct, but semantically wrong (e.g. a SPF file with the wrong content format
    case spErrorWrongContentType = 110002
    //* Some data has a version that we don't know how to handle (can be used with e.g. SPF files, which have explicit version numbers)
    case spErrorWrongContentVersion = 110003
}

// Narrow down completion max rows
let SPNarrowDownCompletionMaxRows: Int = 15
// Default monospaced font name
var SPDefaultMonospacedFontName = "Monaco"
// System database names
var SPMySQLDatabase = "mysql"
var SPMySQLInformationSchemaDatabase = "information_schema"
var SPMySQLPerformanceSchemaDatabase = "performance_schema"
var SPMySQLSysDatabase = "sys"
// Table view drag types
var SPDefaultPasteboardDragType = "SequelProPasteboard"
var SPFavoritesPasteboardDragType = "SPFavoritesPasteboard"
var SPContentFilterPasteboardDragType = "SPContentFilterPasteboard"
var SPNavigatorPasteboardDragType = "SPNavigatorPasteboardDragType"
var SPNavigatorTableDataPasteboardDragType = "SPNavigatorTableDataPasteboardDragType"
var SPExportCustomFileNameTokenPlistType = "SPExportCustomFileNameTokenPlist"
// File extensions
var SPFileExtensionDefault = "spf"
var SPBundleFileExtension = "spfs"
var SPFileExtensionSQL = "sql"
var SPColorThemeFileExtension = "spTheme"
var SPUserBundleFileExtension = "spBundle"
// SPF File types
var SPFExportSettingsContentType = "export settings"
var SPFContentFiltersContentType = "content filters"
var SPFQueryFavoritesContentType = "query favorites"
var SPFConnectionContentType = "connection"
// File names
var SPFavoritesDataFile = "Favorites.plist"
var SPHTMLPrintTemplate = "SPPrintTemplate"
var SPHTMLTableInfoPrintTemplate = "SPTableInfoPrintTemplate"
var SPHTMLHelpTemplate = "SPMySQLHelpTemplate"
var SPPreferenceDefaultsFile = "PreferenceDefaults"
// Folder names
var SPThemesSupportFolder = "Themes"
var SPBundleSupportFolder = "Bundles"
var SPDataSupportFolder = "Data"
// Table filter
var SPTableContentFilterKey = "filter"
// Preference key constants
var SPFirstRun = "SPFirstRun"
// General Prefpane
var SPDefaultFavorite = "DefaultFavorite"
var SPSelectLastFavoriteUsed = "SelectLastFavoriteUsed"
var SPLastFavoriteID = "SPLastFavoriteID"
var SPAutoConnectToDefault = "AutoConnectToDefault"
var SPDefaultViewMode = "DefaultViewMode"
var SPLastViewMode = "LastViewMode"
var SPDefaultEncoding = "DefaultEncodingTag"
var SPUseMonospacedFonts = "UseMonospacedFonts"
var SPDisplayTableViewVerticalGridlines = "DisplayTableViewVerticalGridlines"
var SPCustomQueryMaxHistoryItems = "CustomQueryMaxHistoryItems"
// Tables Prefpane
var SPReloadAfterAddingRow = "ReloadAfterAddingRow"
var SPReloadAfterEditingRow = "ReloadAfterEditingRow"
var SPReloadAfterRemovingRow = "ReloadAfterRemovingRow"
var SPLoadBlobsAsNeeded = "LoadBlobsAsNeeded"
var SPTableRowCountQueryLevel = "TableRowCountQueryLevel"
var SPTableRowCountCheapSizeBoundary = "TableRowCountCheapLookupSizeBoundary"
var SPNewFieldsAllowNulls = "NewFieldsAllowNulls"
var SPLimitResults = "LimitResults"
var SPLimitResultsValue = "LimitResultsValue"
var SPNullValue = "NullValue"
var SPGlobalResultTableFont = "GlobalResultTableFont"
var SPFilterTableDefaultOperator = "FilterTableDefaultOperator"
var SPFilterTableDefaultOperatorLastItems = "FilterTableDefaultOperatorLastItems"
// Favorites Prefpane
var SPFavorites = "favorites"
// Notifications Prefpane
var SPGrowlEnabled = "GrowlEnabled"
var SPShowNoAffectedRowsError = "ShowNoAffectedRowsError"
var SPConsoleEnableLogging = "ConsoleEnableLogging"
var SPConsoleEnableInterfaceLogging = "ConsoleEnableInterfaceLogging"
var SPConsoleEnableCustomQueryLogging = "ConsoleEnableCustomQueryLogging"
var SPConsoleEnableImportExportLogging = "ConsoleEnableImportExportLogging"
var SPConsoleEnableErrorLogging = "ConsoleEnableErrorLogging"
// Network Prefpane
var SPConnectionTimeoutValue = "ConnectionTimeoutValue"
var SPUseKeepAlive = "UseKeepAlive"
var SPKeepAliveInterval = "KeepAliveInterval"
// Editor Prefpane
var SPCustomQueryEditorFont = "CustomQueryEditorFont"
var SPCustomQueryEditorTextColor = "CustomQueryEditorTextColor"
var SPCustomQueryEditorBackgroundColor = "CustomQueryEditorBackgroundColor"
var SPCustomQueryEditorCaretColor = "CustomQueryEditorCaretColor"
var SPCustomQueryEditorCommentColor = "CustomQueryEditorCommentColor"
var SPCustomQueryEditorSQLKeywordColor = "CustomQueryEditorSQLKeywordColor"
var SPCustomQueryEditorNumericColor = "CustomQueryEditorNumericColor"
var SPCustomQueryEditorQuoteColor = "CustomQueryEditorQuoteColor"
var SPCustomQueryEditorBacktickColor = "CustomQueryEditorBacktickColor"
var SPCustomQueryEditorVariableColor = "CustomQueryEditorVariableColor"
var SPCustomQueryEditorHighlightQueryColor = "CustomQueryEditorHighlightQueryColor"
var SPCustomQueryEditorSelectionColor = "CustomQueryEditorSelectionColor"
var SPCustomQueryAutoIndent = "CustomQueryAutoIndent"
var SPCustomQueryAutoPairCharacters = "CustomQueryAutoPairCharacters"
var SPCustomQueryAutoUppercaseKeywords = "CustomQueryAutoUppercaseKeywords"
var SPCustomQueryUpdateAutoHelp = "CustomQueryUpdateAutoHelp"
var SPCustomQueryAutoHelpDelay = "CustomQueryAutoHelpDelay"
var SPCustomQueryHighlightCurrentQuery = "CustomQueryHighlightCurrentQuery"
var SPCustomQueryEditorTabStopWidth = "CustomQueryEditorTabStopWidth"
var SPCustomQueryEditorCompleteWithBackticks = "SPCustomQueryEditorCompleteWithBackticks"
var SPCustomQueryAutoComplete = "CustomQueryAutoComplete"
var SPCustomQueryAutoCompleteDelay = "CustomQueryAutoCompleteDelay"
var SPCustomQueryFunctionCompletionInsertsArguments = "CustomQueryFunctionCompletionInsertsArguments"
var SPCustomQueryEditorThemeName = "CustomQueryEditorThemeName"
var SPCustomQuerySoftIndent = "CustomQuerySoftIndent"
var SPCustomQuerySoftIndentWidth = "CustomQuerySoftIndentWidth"
// AutoUpdate Prefpane
var SPLastUsedVersion = "LastUsedVersion"
// GUI Prefs
var SPConsoleShowHelps = "ConsoleShowHelps"
var SPConsoleShowSelectsAndShows = "ConsoleShowSelectsAndShows"
var SPConsoleShowTimestamps = "ConsoleShowTimestamps"
var SPConsoleShowConnections = "ConsoleShowConnections"
var SPConsoleShowDatabases = "ConsoleShowDatabases"
var SPEditInSheetEnabled = "EditInSheetEnabled"
var SPTableInformationPanelCollapsed = "TableInformationPanelCollapsed"
var SPTableColumnWidths = "tableColumnWidths"
var SPProcessListTableColumnWidths = "ProcessListTableColumnWidths"
var SPProcessListShowProcessID = "ProcessListShowProcessID"
var SPProcessListShowFullProcessList = "ProcessListShowFullProcessList"
var SPProcessListEnableAutoRefresh = "ProcessListEnableAutoRefresh"
var SPProcessListAutoRrefreshInterval = "ProcessListAutoRrefreshInterval"
var SPFavoritesSortedBy = "FavoritesSortedBy"
var SPFavoritesSortedInReverse = "FavoritesSortedInReverse"
var SPAlwaysShowWindowTabBar = "WindowAlwaysShowTabBar"
var SPResetAutoIncrementAfterDeletionOfAllRows = "ResetAutoIncrementAfterDeletionOfAllRows"
var SPFavoriteColorList = "FavoriteColorList"
var SPDisplayBinaryDataAsHex = "DisplayBinaryDataAsHex"
var SPMonospacedFontSize = "MonospacedFontSize"
// Hidden Prefs
var SPPrintWarningRowLimit = "PrintWarningRowLimit"
var SPDisplayServerVersionInWindowTitle = "DisplayServerVersionInWindowTitle"
var SPLongRunningQueryNotificationTime = "LongRunningQueryNotificationTime"
var SPAlphabeticalTableSorting = "AlphabeticalTableSorting"
// Import and export
var SPCSVImportFieldEnclosedBy = "CSVImportFieldEnclosedBy"
var SPCSVImportFieldEscapeCharacter = "CSVImportFieldEscapeCharacter"
var SPCSVImportFieldTerminator = "CSVImportFieldTerminator"
var SPCSVImportFirstLineIsHeader = "CSVImportFirstLineIsHeader"
var SPCSVImportLineTerminator = "CSVImportLineTerminator"
var SPCSVFieldImportMappingAlignment = "CSVFieldImportMappingAlignment"
var SPImportClipboardTempFileNamePrefix = "/tmp/_SP_ClipBoard_Import_File_"
var SPLastExportSettings = "LastExportSettings"
// Export filename tokens
var SPFileNameDatabaseTokenName = "database"
var SPFileNameHostTokenName = "host"
var SPFileNameDateTokenName = "date"
var SPFileNameYearTokenName = "year"
var SPFileNameMonthTokenName = "month"
var SPFileNameDayTokenName = "day"
var SPFileNameTimeTokenName = "time"
var SPFileName24HourTimeTokenName = "time24"
var SPFileNameFavoriteTokenName = "favorite"
var SPFileNameTableTokenName = "table"
// Misc 
var SPContentFilters = "ContentFilters"
var SPDocumentTaskEndNotification = "DocumentTaskEnded"
var SPDocumentTaskStartNotification = "DocumentTaskStarted"
var SPDocumentWillCloseNotification = "DocumentWillClose"
var SPActivitiesUpdateNotification = "ActivitiesUpdateNotification"
var SPWindowToolbarDidToggleNotification = "WindowToolbarWasToggledNotification"
var SPFieldEditorSheetFont = "FieldEditorSheetFont"
var SPLastSQLFileEncoding = "lastSqlFileEncoding"
var SPPrintBackground = "PrintBackground"
var SPPrintImagePreviews = "PrintImagePreviews"
var SPQueryFavorites = "queryFavorites"
var SPQueryFavoriteReplacesContent = "QueryFavoriteReplacesContent"
var SPQueryHistory = "queryHistory"
var SPQueryHistoryReplacesContent = "QueryHistoryReplacesContent"
var SPQueryPrimaryControlRunsAll = "QueryPrimaryControlRunsAll"
var SPQuickLookTypes = "QuickLookTypes"
var SPTableChangedNotification = "SPTableSelectionChanged"
var SPTableInfoChangedNotification = "SPTableInformationChanged"
var SPBlobTextEditorSpellCheckingEnabled = "BlobTextEditorSpellCheckingEnabled"
var SPUniqueSchemaDelimiter = "￸" // U+FFF8
var SPLastImportIntoNewTableEncoding = "LastImportIntoNewTableEncoding"
var SPLastImportIntoNewTableType = "LastImportIntoNewTableType"
var SPGlobalValueHistory = "GlobalValueHistory"
var SPBundleDeletedDefaultBundlesKey = "deletedDefaultBundles"
var SPHiddenKeyFileVisibilityKey = "KeySelectionHiddenFilesVisibility"
var SPSelectionDetailTypeIndexed = "SelectionDetailTypeNSIndexSet"
var SPSelectionDetailTypePrimaryKeyed = "SelectionDetailTypePrimaryKeyedDetails"
var SPSSHEnableMuxingPreference = "SSHMultiplexingEnabled"
var SPSSHClientPath = "SSHClientPath"
var SPSSLCipherListKey = "SSLCipherList"
var SPQueryFavoritesHaveBeenUpdatedNotification = "QueryFavoritesHaveBeenUpdatedNotification"
var SPHistoryItemsHaveBeenUpdatedNotification = "HistoryItemsHaveBeenUpdatedNotification"
var SPContentFiltersHaveBeenUpdatedNotification = "ContentFiltersHaveBeenUpdatedNotification"
var SPCopyContentOnTableCopy = "CopyContentOnTableCopy"
// URLs
var SPDonationsURL = "https://www.sequelpro.com/donate/"
var SPMySQLSearchURL = "https://dev.mysql.com/doc/refman/%@/%@/%@.html"
var SPDevURL = "https://github.com/sequelpro/sequelpro"
// Toolbar constants

// Main window toolbar
var SPMainToolbarDatabaseSelection = "DatabaseSelectToolbarItemIdentifier"
var SPMainToolbarHistoryNavigation = "HistoryNavigationToolbarItemIdentifier"
var SPMainToolbarShowConsole = "ShowConsoleIdentifier"
var SPMainToolbarClearConsole = "ClearConsoleIdentifier"
var SPMainToolbarTableStructure = "SwitchToTableStructureToolbarItemIdentifier"
var SPMainToolbarTableContent = "SwitchToTableContentToolbarItemIdentifier"
var SPMainToolbarCustomQuery = "SwitchToRunQueryToolbarItemIdentifier"
var SPMainToolbarTableInfo = "SwitchToTableInfoToolbarItemIdentifier"
var SPMainToolbarTableRelations = "SwitchToTableRelationsToolbarItemIdentifier"
var SPMainToolbarTableTriggers = "SwitchToTableTriggersToolbarItemIdentifier"
var SPMainToolbarUserManager = "SwitchToUserManagerToolbarItemIdentifier"
var SPViewModeToMainToolbarMap = [nil, SPMainToolbarTableStructure, SPMainToolbarTableContent, SPMainToolbarCustomQuery, SPMainToolbarTableInfo, SPMainToolbarTableRelations, SPMainToolbarTableTriggers]
// Preferences toolbar
var SPPreferenceToolbarGeneral = "SPPreferenceToolbarGeneral"
var SPPreferenceToolbarTables = "SPPreferenceToolbarTables"
var SPPreferenceToolbarFavorites = "SPPreferenceToolbarFavorites"
var SPPreferenceToolbarNotifications = "SPPreferenceToolbarNotifications"
var SPPreferenceToolbarAutoUpdate = "SPPreferenceToolbarAutoUpdate"
var SPPreferenceToolbarNetwork = "SPPreferenceToolbarNetwork"
var SPPreferenceToolbarEditor = "SPPreferenceToolbarEditor"
var SPPreferenceToolbarShortcuts = "SPPreferenceToolbarShortcuts"
// Connection favorite keys
var SPFavoritesRootKey = "Favorites Root"
var SPFavoriteChildrenKey = "Children"
var SPFavoritesGroupNameKey = "Name"
var SPFavoritesGroupIsExpandedKey = "IsExpanded"
var SPFavoriteIDKey = "id"
var SPFavoriteNameKey = "name"
var SPFavoriteDatabaseKey = "database"
var SPFavoriteHostKey = "host"
var SPFavoritePortKey = "port"
var SPFavoriteUserKey = "user"
var SPFavoriteColorIndexKey = "colorIndex"
var SPFavoriteTypeKey = "type"
var SPFavoriteSocketKey = "socket"
var SPFavoriteSSHHostKey = "sshHost"
var SPFavoriteSSHPortKey = "sshPort"
var SPFavoriteSSHUserKey = "sshUser"
var SPFavoriteSSHKeyLocationEnabledKey = "sshKeyLocationEnabled"
var SPFavoriteSSHKeyLocationKey = "sshKeyLocation"
var SPFavoriteUseSSLKey = "useSSL"
var SPFavoriteSSLKeyFileLocationEnabledKey = "sslKeyFileLocationEnabled"
var SPFavoriteSSLKeyFileLocationKey = "sslKeyFileLocation"
var SPFavoriteSSLCertificateFileLocationEnabledKey = "sslCertificateFileLocationEnabled"
var SPFavoriteSSLCertificateFileLocationKey = "sslCertificateFileLocation"
var SPFavoriteSSLCACertFileLocationEnabledKey = "sslCACertFileLocationEnabled"
var SPFavoriteSSLCACertFileLocationKey = "sslCACertFileLocation"
var SPFavoriteUseCompressionKey = "useCompression"
var SPConnectionFavoritesChangedNotification = "SPConnectionFavoritesChanged"
var SPFFormatKey = "format"
var SPFVersionKey = "version"
// Favorites import/export
var SPFavoritesDataRootKey = "SPConnectionFavorites"
// Bundle Files and Bundle Editor
var SPBundleScopeQueryEditor = "editor"
var SPBundleScopeDataTable = "datatable"
var SPBundleScopeInputField = "inputfield"
var SPBundleScopeGeneral = "general"
var SPBundleInputSourceSelectedText = "selectedtext"
var SPBundleInputSourceEntireContent = "entirecontent"
var SPBundleInputSourceCurrentWord = "currentword"
var SPBundleInputSourceCurrentQuery = "currentquery"
var SPBundleInputSourceCurrentLine = "currentline"
var SPBundleInputSourceSelectedTableRowsAsTab = "selectedtablerowsastab"
var SPBundleInputSourceSelectedTableRowsAsCsv = "selectedtablerowsascsv"
var SPBundleInputSourceSelectedTableRowsAsSqlInsert = "selectedtablerowsassqlinsert"
var SPBundleInputSourceTableRowsAsTab = "tablerowsastab"
var SPBundleInputSourceTableRowsAsCsv = "tablerowsascsv"
var SPBundleInputSourceTableRowsAsSqlInsert = "tablerowsassqlinsert"
var SPBundleInputSourceNone = "none"
var SPBundleInputSourceBlobHandlingInclude = "include"
var SPBundleInputSourceBlobHandlingExclude = "exclude"
var SPBundleInputSourceBlobHandlingImageFileReference = "imagefilereference"
var SPBundleInputSourceBlobHandlingFileReference = "filereference"
var SPBundleOutputActionNone = "none"
var SPBundleOutputActionInsertAsText = "insertastext"
var SPBundleOutputActionInsertAsSnippet = "insertassnippet"
var SPBundleOutputActionReplaceSelection = "replaceselection"
var SPBundleOutputActionReplaceContent = "replacecontent"
var SPBundleOutputActionShowAsTextTooltip = "showastexttooltip"
var SPBundleOutputActionShowAsHTMLTooltip = "showashtmltooltip"
var SPBundleOutputActionShowAsHTML = "showashtml"
var SPBundleTriggerActionNone = "none"
var SPBundleTriggerActionDatabaseChanged = "databasechanged"
var SPBundleTriggerActionTableChanged = "tablechanged"
var SPBundleTriggerActionTableRowChanged = "tablerowchanged"
var SPBundleFileCommandKey = "command"
var SPBundleFileScopeKey = "scope"
var SPBundleFileNameKey = "name"
var SPBundleFileCategoryKey = "category"
var SPBundleFileInputSourceKey = "input"
var SPBundleFileInputSourceFallBackKey = "input_fallback"
var SPBundleFileOutputActionKey = "output"
var SPBundleFileKeyEquivalentKey = "keyEquivalent"
var SPBundleFileInternalKeyEquivalentKey = "internalKeyEquivalent"
var SPBundleFileInternalexecutionUUID = "exeUUID"
var SPBundleFileTooltipKey = "tooltip"
var SPBundleFileDisabledKey = "disabled"
var SPBundleFileAuthorKey = "author"
var SPBundleFileContactKey = "contact"
var SPBundleFileUUIDKey = "uuid"
var SPBundleFileDescriptionKey = "description"
var SPBundleFileTriggerKey = "trigger"
var SPBundleFileWithBlobKey = "withblob"
var SPBundleFileIsDefaultBundleKey = "isDefaultBundle"
var SPBundleFileDefaultBundleWasModifiedKey = "defaultBundleWasModified"
var SPBundleInternLabelKey = "label"
var SPBundleInternPathToFileKey = "path"
var SPBundleInternKeyEquivalentKey = "keyEquivalent"
var SPBundleFileName = "command.plist"
var SPBundleTaskInputFilePath = "/tmp/SP_BUNDLE_INPUT"
var SPBundleTaskOutputFilePath = "/tmp/SP_BUNDLE_OUTPUT"
var SPBundleTaskScriptCommandFilePath = "/tmp/SP_BUNDLE_SCRIPT_COMMAND"
var SPBundleTaskCopyBlobFileDirectory = "/tmp/SP_BUNDLE_COPY_BLOB_FILES"
var SPBundleTaskTableMetaDataFilePath = "/tmp/SP_BUNDLE_TABLE_META_DATA"
var SPBundleShellVariableAllDatabases = "SP_ALL_DATABASES"
var SPBundleShellVariableAllFunctions = "SP_ALL_FUNCTIONS"
var SPBundleShellVariableAllProcedures = "SP_ALL_PROCEDURES"
var SPBundleShellVariableAllTables = "SP_ALL_TABLES"
var SPBundleShellVariableAllViews = "SP_ALL_VIEWS"
var SPBundleShellVariableAppResourcesDirectory = "SP_APP_RESOURCES_DIRECTORY"
var SPBundleShellVariableBlobFileDirectory = "SP_BUNDLE_BLOB_FILES_DIRECTORY"
var SPBundleShellVariableBundlePath = "SP_BUNDLE_PATH"
var SPBundleShellVariableBundleScope = "SP_BUNDLE_SCOPE"
var SPBundleShellVariableCurrentEditedColumnName = "SP_CURRENT_EDITED_COLUMN_NAME"
var SPBundleShellVariableCurrentEditedTable = "SP_CURRENT_EDITED_TABLE"
var SPBundleShellVariableCurrentHost = "SP_CURRENT_HOST"
var SPBundleShellVariableCurrentLine = "SP_CURRENT_LINE"
var SPBundleShellVariableCurrentPort = "SP_CURRENT_PORT"
var SPBundleShellVariableCurrentQuery = "SP_CURRENT_QUERY"
var SPBundleShellVariableCurrentUser = "SP_CURRENT_USER"
var SPBundleShellVariableCurrentWord = "SP_CURRENT_WORD"
var SPBundleShellVariableDatabaseEncoding = "SP_DATABASE_ENCODING"
var SPBundleShellVariableDataTableSource = "SP_DATA_TABLE_SOURCE"
var SPBundleShellVariableExitShowAsHTML = "SP_BUNDLE_EXIT_SHOW_AS_HTML"
var SPBundleShellVariableExitShowAsHTMLTooltip = "SP_BUNDLE_EXIT_SHOW_AS_HTML_TOOLTIP"
var SPBundleShellVariableExitInsertAsSnippet = "SP_BUNDLE_EXIT_INSERT_AS_SNIPPET"
var SPBundleShellVariableExitInsertAsText = "SP_BUNDLE_EXIT_INSERT_AS_TEXT"
var SPBundleShellVariableExitShowAsTextTooltip = "SP_BUNDLE_EXIT_SHOW_AS_TEXT_TOOLTIP"
var SPBundleShellVariableExitNone = "SP_BUNDLE_EXIT_NONE"
var SPBundleShellVariableExitReplaceContent = "SP_BUNDLE_EXIT_REPLACE_CONTENT"
var SPBundleShellVariableExitReplaceSelection = "SP_BUNDLE_EXIT_REPLACE_SELECTION"
var SPBundleShellVariableIconFile = "SP_ICON_FILE"
var SPBundleShellVariableInputFilePath = "SP_BUNDLE_INPUT"
var SPBundleShellVariableInputTableMetaData = "SP_BUNDLE_INPUT_TABLE_METADATA"
var SPBundleShellVariableOutputFilePath = "SP_BUNDLE_OUTPUT"
var SPBundleShellVariableProcessID = "SP_PROCESS_ID"
var SPBundleShellVariableQueryFile = "SP_QUERY_FILE"
var SPBundleShellVariableQueryResultFile = "SP_QUERY_RESULT_FILE"
var SPBundleShellVariableQueryResultMetaFile = "SP_QUERY_RESULT_META_FILE"
var SPBundleShellVariableQueryResultStatusFile = "SP_QUERY_RESULT_STATUS_FILE"
var SPBundleShellVariableRDBMSType = "SP_RDBMS_TYPE"
var SPBundleShellVariableRDBMSVersion = "SP_RDBMS_VERSION"
var SPBundleShellVariableSelectedDatabase = "SP_SELECTED_DATABASE"
var SPBundleShellVariableSelectedRowIndices = "SP_SELECTED_ROW_INDICES"
var SPBundleShellVariableSelectedTable = "SP_SELECTED_TABLE"
var SPBundleShellVariableSelectedTables = "SP_SELECTED_TABLES"
var SPBundleShellVariableSelectedText = "SP_SELECTED_TEXT"
var SPBundleShellVariableSelectedTextRange = "SP_SELECTED_TEXT_RANGE"
var SPBundleShellVariableUsedQueryForTable = "SP_USED_QUERY_FOR_TABLE"
let OWS = "\\s*"
//                                                    CURRENT_TIMESTAMP    [            (           [n]          )    ]var SPURLSchemeQueryInputPathHeader = "/tmp/SP_QUERY_"
var SPURLSchemeQueryResultPathHeader = "/tmp/SP_QUERY_RESULT_"
var SPURLSchemeQueryResultStatusPathHeader = "/tmp/SP_QUERY_RESULT_STATUS_"
var SPURLSchemeQueryResultMetaPathHeader = "/tmp/SP_QUERY_META_"
var SPCommonCryptoExceptionName = "SPCommonCryptoException"
var SPErrorDomain = "SPErrorDomain"

@inline(__always) func SPClear(addr: Any?) {
    var addr = addr
    addr = nil
}
