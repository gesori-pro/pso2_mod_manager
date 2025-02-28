import 'package:json_annotation/json_annotation.dart';

part 'ui_text.g.dart';

@JsonSerializable()
class TranslationLanguage {
  TranslationLanguage(this.langInitial, this.revision, this.langFilePath, this.selected);

  String langInitial;
  int revision;
  String langFilePath;
  bool selected;

  factory TranslationLanguage.fromJson(Map<String, dynamic> json) => _$TranslationLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationLanguageToJson(this);
}

@JsonSerializable()
class TranslationText {
  TranslationText();
  //General elements
  String uiCancel = 'Cancel',
      uiAdd = 'Add',
      uiDismiss = 'Dismiss',
      uiBack = 'Back',
      uiError = 'Error',
      uiApply = 'Apply',
      uiClose = 'Close',
      uiReset = 'Reset',
      uiGotIt = 'Got it',
      uiReturn = 'Return',
      uiSure = 'Sure',
      uiYes = 'Yes',
      uiNo = 'No',
      uiClearAll = 'Clear All',
      uiExit = 'Exit',
      uiON = 'ON',
      uiOFF = 'OFF',
      uiMove = 'Move',
      uiContinue = 'Continue',
      uiUnknown = 'Unknown',
      uiUnknownItem = 'Unknown Item',
      uiUnknownAccessory = 'Unknown Accessory',
      uiUnknownEmote = 'Unknown Emote',
      uiUnknownMotion = 'Unknown Motion',
      uiGenderMale = 'Male',
      uiGenderFemale = 'Female',
      uiGenderBoth = 'Both';

  //Default category types
  String dfCastParts = 'Cast Parts', dfLayeringWears = 'Layering Wears', dfOthers = 'Others';

  //Default category names
  String dfAccessories = 'Accessories', //0
      dfBasewears = 'Basewears', //1
      dfBodyPaints = 'Body Paints', //2
      dfCastArmParts = 'Cast Arm Parts', //3
      dfCastBodyParts = 'Cast Body Parts', //4
      dfCastLegParts = 'Cast Leg Parts', //5
      dfCostumes = 'Costumes', //6
      dfEmotes = 'Emotes', //7
      dfEyes = 'Eyes', //8
      dfFacePaints = 'Face Paints', //9
      dfHairs = 'Hairs', //10
      dfInnerwears = 'Innerwears', //11
      dfMags = 'Mags', //12
      dfMisc = 'Misc', //13
      dfMotions = 'Motions', //14
      dfOuterwears = 'Outerwears', //15
      dfSetwears = 'Setwears'; //16

  //main page
  String uiSettings = 'Settings',
      uiLanguage = 'Language',
      uiAddANewLanguage = 'Add a new language',
      uiNewLanguageInititalInput = 'Enter new language\'s initial:\n(2 characters, ex: EN for English)',
      uiNewLanguageInitialEmptyError = 'Language initial can\'t be empty',
      uiNewLanguageInititalAlreadyExisted = 'Language initial already existed',
      uiCurrentLanguage = 'Current Language',
      uiReselectPso2binPath = 'Reselect pso2_bin Path',
      uiReselectModManFolderPath = 'Reselect Mod Manager Folder Path',
      uiOpenModsFolder = 'Open Mods Folder',
      uiOpenBackupFolder = 'Open Backup Folder',
      uiOpenDeletedItemsFolder = 'Open Deleted Items Folder',
      uiTheme = 'Theme',
      uiSwitchToDarkTheme = 'Switch to dark theme',
      uiSwitchToLightTheme = 'Switch to light theme',
      uiAppearance = 'Appearance',
      uiDarkTheme = 'Dark Theme',
      uiLightTheme = 'Light Theme',
      uiUIOpacity = 'UI Opacity',
      uiUIColors = 'UI Colors',
      uiPrimarySwatch = 'Primary swatch',
      uiMainUIBackground = 'Main UI background',
      uiPrimaryColor = 'Primary color',
      uiPrimaryLight = 'Primary light',
      uiPrimaryDark = 'Primary dark',
      uiMainCanvasBackground = 'Main canvas background',
      uiHoldToResetColors = 'Hold to reset to default colors',
      uiBackgroundImage = 'Background Image',
      uiClicktoChangeBackgroundImage = 'Click to change',
      uiNoBackgroundImageFound = 'No image found. Click!',
      uiSelectBackgroundImage = 'Select your image',
      uiHideBackgroundImage = 'Hide background image',
      uiShowBackgroundImage = 'Show background image',
      uiHoldToRemoveBackgroundImage = 'Hold to remove background image',
      uiVersion = 'Version',
      uiMadeBy = 'Made by',
      uiNewUpdateAvailableClickToDownload = 'New update available. Click to go to download page',
      uiAddNewModsToMM = 'Add new mods to Mod Manager',
      uiAddMods = 'Add Mods',
      uiManageModSets = 'Manage Mod Sets',
      uiManageModList = 'Manage Mod List',
      uiModSets = 'Mod Sets',
      uiModList = 'Mod List',
      uiRefreshMM = 'Refresh Mod Manager',
      uiRefresh = 'Refresh',
      uiOpenChecksumFolder = 'Open Checksum Folder',
      uiChecksumDownloadSelect = 'Click to download or hold to manually select checksum',
      uiSelectLocalChecksum = 'Select your checksum file',
      uiChecksum = 'Checksum',
      uiChecksumMissingClick = 'Checksum missing. Click!',
      uiChecksumOutdatedClick = 'Checksum outdated. Click!',
      uiChecksumDownloading = 'Downloading checksum..',
      uiPreviewShowHide = 'Show/Hide Preview window',
      uiPreview = 'Preview',
      uiOpenMMSettings = 'Open Mod Manager Settings',
      uiNewMMUpdateAvailable = 'New Mod Manager update available!',
      uiNewVersion = 'New Version',
      uiCurrentVersion = 'Current Version',
      uiPatchNote = 'Patch Notes...',
      uiSkipMMUpdate = 'Skip This Version',
      uiUpdate = 'Update',
      uiNewRefSheetsUpdate = 'New update available for item reference sheets (Important for many features to work correctly)',
      uiDownloading = 'Downloading',
      uiOf = 'of',
      uiRefSheetsDownloadingCount = 'of the required item reference sheets.',
      uiDownloadUpdate = 'Download Update',
      uiNewUserNotice = 'If this is your first time using PSO2NGS Mod Manager please restore the game files to their originals before applying mods to the game',
      uiUpdateNow = 'Update Now',
      uiTurnOffStartupIconsFetching = 'Turn off startup item icons fetching',
      uiTurnOnStartupIconsFetching = 'Turn on startup item icons fetching',
      uiStartupItemIconsFetching = 'Startup Item Icons Fetching',
      uiTurnOffSlidingItemIcons = 'Turn off sliding item icons',
      uiTurnOnSlidingItemIcons = 'Turn on sliding item icons',
      uiSlidingItemIcons = 'Sliding Item Icons',
      uiWillNotFetchItemIcon = 'Will not fetch item icons on startup',
      uiOnlyFetchOneIcon = 'Only fetch one icon for each item',
      uiFetchAllMissingItemIcons = 'Fetch all missing icons that included in each mods',
      uiMinimal = 'Minimal',
      uiAll = 'All',
      uiSwapItems = 'Swap Items',
      uiSwapAnItemToAnotherItem = 'Swap an item to another item',
      uiProfiles = 'Profiles',
      uiClickToChangeToThisProfileHoldToRename = 'Click to change to this profile, hold to rename',
      uiVitalGauge = 'Vital Gauge',
      uiCreateAndSwapVitalGaugeBackground = 'Create and swap Vital Gauge background',
      uiRemoveProfanityFilter = "Profanity Filter Removal",
      uiExtras = 'Extras',
      uiOtherFeaturesOfPSO2NGSModManager = 'Other features of PSO2NGS Mod Manager',
      uiAutoRadiusRemovalTooltip = 'Automatically remove bounding radius upon applying mods to the game\nThis applies to [Ba], [Ou], [Se], [Fu], and Cast parts',
      uiAutoBoundaryRadiusRemoval = 'Auto Bounding Radius Removal',
      uiPrioritizeLocalBackupTooltip = 'Mod Manager will prioritize selected backup method, either from Sega servers or local',
      uiPrioritizeLocalBackups = 'Backup Priority: Local',
      uiPrioritizeSegaBackups = 'Backup Priority: Sega Servers',
      uiCmxRefreshToolTip = 'Refresh all cmx, use this if cmx settings are not working correctly',
      uiRefreshingCmx = 'Refreshing cmx',
      uiRefreshCmx = 'Refresh cmx Settings',
      uiItemNameLanguage = 'Item Name Language',
      uiItemNameLanguageTooltip = 'Only applies to item names in list when adding mods or swapping items';

  //homepage
  String uiItemList = 'Item List',
      uiLoadingUILanguage = 'Loading UI Language',
      uiReloadingMods = 'Reloading Mods',
      uiShowFavList = 'Show Favorite List',
      uiFavItemList = 'Favorite Item List',
      uiUnhideAllCate = 'Unhide all categories',
      uiTurnOffAutoHideEmptyCate = 'Turn off auto hide empty categories',
      uiTurnOnAutoHideEmptyCate = 'Turn on auto hide empty categories',
      uiShowHideCate = 'Show/Hide categories',
      uiHiddenItemList = 'Hidden Item List',
      uiSortByNameDescen = 'Sort by name descending',
      uiSortByNameAscen = 'Sort by name ascending',
      uiSortItemList = 'Sort Item List',
      uiAddNewCateGroup = 'Add new Category Group',
      uiSearchForMods = 'Search for mods',
      uiUnhide = 'Unhide',
      uiItem = 'Item',
      uiItems = 'Items',
      uiRemove = 'Remove',
      uiFromFavList = 'from Favorite List',
      uiMod = 'Mod',
      uiMods = 'Mods',
      uiApplied = 'Applied',
      uiOpen = 'Open',
      uiInFileExplorer = 'in File Explorer',
      uiHoldToRemove = 'Hold to remove',
      uiFromMM = 'from Mod Manager',
      uiSuccess = 'Success',
      uiSuccessfullyRemoved = 'Successfully removed',
      uiHoldToDelete = 'Hold to delete',
      uiSortCateInThisGroup = 'Sort categories in this group',
      uiAddANewCateTo = 'Add a new Category to',
      uiHoldToHide = 'Hold to hide',
      uiFromItemList = 'from Item List',
      uiFrom = 'from',
      uiClearAvailableModsView = 'Clear Available Mods view',
      uiAvailableMods = 'Available Mods',
      uiVariant = 'Variant',
      uiVariants = 'Variants',
      uiFromTheGame = 'from the game',
      uiCouldntFindBackupFileFor = 'Could not find backup file for',
      uiToTheGame = 'to the game',
      uiCouldntFindOGFileFor = 'Could not find original file for',
      uiSuccessfullyApplied = 'Sucessfully applied',
      uiToFavList = 'to Favorite List',
      uiHoldToRemoveAllAppliedMods = 'Hold to remove all applied mods from the game',
      uiAddAllAppliedModsToSets = 'Add all applied mods to Mod Sets',
      uiAppliedMods = 'Applied Mods',
      uiFilesApplied = 'Files applied',
      uiNoPreViewAvailable = 'No preview available',
      uiCreateNewModSet = 'Create new Mod Set',
      uiEnterNewModSetName = 'Enter new Mod Set name',
      uiRemoveAllModsIn = 'Remove all mods in',
      uiSuccessfullyRemoveAllModsIn = 'Successfully removed all mods in',
      uiApplyAllModsIn = 'Apply all mods in',
      uiSuccessfullyAppliedAllModsIn = 'Sucessfully applied all mods in',
      uiAddToThisSet = 'Add to this set',
      uiFromThisSet = 'from this set',
      uiToAnotherItem = 'to another item',
      uiUnableToObtainOrginalFilesFromSegaServers = 'Unable to obtain original files from Sega\'s servers',
      uiSwitchingProfile = 'Switching Profile',
      uiProfile = 'Profile',
      uiHoldToApplyAllAvailableModsToTheGame =
          'Hold to apply all available mods to the game\nNote: this will apply the first variant of the first mod of all items to the game and ignores the ones that already have mods applied',
      uiHoldToReapplyAllModsInAppliedList = 'Hold to reapply all mods in Applied Mods list',
      uiHoldToModifyBoundaryRadius = 'Hold to modify bounding radius',
      uiAddToFavList = 'Add to Favorite List',
      uiRemoveFromFavList = 'Remove from Favorite List',
      uiMore = 'More',
      uiSwapToAnotherItem = 'Swap to another item',
      uiRemoveBoundaryRadius = 'Remove bounding radius',
      uiRemoveFromMM = 'Remove from Mod Manager',
      uiAddToModSets = 'Add to Mod Sets',
      uiRemoveFromThisSet = 'Remove from this set',
      uiSelect = "Select",
      uiDeselect = "Deselect",
      uiSelectAllAppliedMods = "Select all applied mods",
      uiDeselectAllAppliedMods = "Deselect all applied mods",
      uiSelectAll = "Select All",
      uiDeselectAll = "Deselect All",
      uiHoldToReapplySelectedMods = "Hold to reapply selected mods to the game",
      uiHoldToRemoveSelectedMods = "Hold to remove selected mods from the game",
      uiAddSelectedModsToModSets = "Add selected mods to Mod Sets",
      uiFailed = "Failed",
      uiFailedToRemove = "Failed to remove",
      uiUnknownErrorWhenRemovingModFromTheGame = "Unknown error when trying to remove mod files from the game",
      uiSuccessWithErrors = "Success with errors",
      uiCmx = "cmx",
      uiAddChangeCmxFile = "Add/Change cmx file",
      uiCmxFile = "cmx file",
      uiMoveThisCategoryToAnotherGroup = "Move this category to another group",
      uiUnhideX = "Unhide <x>",
      uiRemoveXFromFav = "Remove <x> from Favorite List",
      uiOpenXInFileExplorer = "Open <x> in File Explorer",
      uiHoldToRemoveXFromModMan = "Hold to remove <x> from Mod Manager",
      uiSuccessfullyRemovedXFromModMan = "Successfully removed <x> from Mod Manager",
      uiSuccessfullyAppliedX = "Successfully applied <x>\n",
      uiSuccessfullyAppliedXInY = "Successfully applied <x> > <y>\n",
      uiAddNewCateToXGroup = "Add new category to <x>",
      uiHoldToHideXFromItemList = "Hold to hide <x> from Item List",
      uiHoldToRemoveXfromY = "Hold to remove <x> from <y>",
      uiApplyXToTheGame = "Apply <x> to the game",
      uiRemoveXFromTheGame = "Remove <x> from the game",
      uiApplyAllModsInXToTheGame = "Apply all mods in <x> to the game",
      uiRemoveAllModsInXFromTheGame = "Remove all mods in <x> from the game",
      uiHoldToRemoveXFromThisSet = "Hold to remove <x> from this Set",
      uiSuccessfullyRemovedXFromY = "Successfully removed <x> > from <y>",
      uiSelectX = "Select <x>",
      uiDeselectX = "Deselect <x>",
      uiDirNotFound = "Directory location not found";

  //mod_add_handler
  String uiPreparing = 'Preparing',
      uiDragDropFiles = 'Drag and drop folders, zip files\nand .ice files here\nOr use the "Add Folders/Files" buttons to select folders/files\nMay take some time\nto process large amount of files',
      uiAchiveCurrentlyNotSupported = 'currently not supported. Open the archive file then drag the content in here instead',
      uiProcess = 'Process',
      uiWaitingForData = 'Waiting for data',
      uiErrorWhenLoadingAddModsData = 'Error when loading data for Mods Adder. Please restart the app.',
      uiProcessingFiles = 'Processing files',
      uiSelectACategory = 'Select a Category',
      uiEditName = 'Edit Name',
      uiMarkThisNotToBeAdded = 'Mark this not to be added',
      uiMarkThisToBeAdded = 'Mark this to be added',
      uiNameCannotBeEmpty = 'Name cannot be empty',
      uiRename = 'Rename',
      uiBeforeAdding = 'before adding',
      uiThereAreStillModsThatWaitingToBeAdded = 'There are still mods in the list waiting to be added',
      uiModsAddedSuccessfully = 'Mods added successfully!',
      uiAddAll = 'Add To Mod Mananager',
      uiDuplicateNamesFound = 'Duplicate mod name(s) found',
      uiRenameTheModsBelowBeforeAdding = 'Rename the mods below before adding',
      uiDuplicateModsIn = 'in',
      uiRenameForMe = 'Rename for me!',
      uiAddingMods = 'Adding mods';

  //color_picker
  String uiPickAColor = 'Pick a color';

  //modfiles_apply
  String uiDuplicatesInAppliedModsFound = 'Duplicate(s) in applied mods found', uiApplyingWouldReplaceModFiles = 'Applying this mod would replace these applied mod files';

  //new_cate_adder
  String uiNewCateGroup = 'New Category Group',
      uiNameAlreadyExisted = 'Name already existed!',
      uiNewCateGroupName = 'New Category Group name',
      uiNewCate = 'New Category',
      uiNewCateName = 'New Category name',
      uiRemovingCateGroup = 'Removing Category Group',
      uiCateFoundWhenDeletingGroup = 'There is a Category in this group. Would you like to move it to "Others" Group?',
      uiThereAre = 'There are',
      uiCatesFoundWhenDeletingGroup = 'Categories in this group. Would you like to move them to Others Group?',
      uiMoveEverythingToOthers = 'Move everything to "Others"',
      uiNoDeleteAll = 'No, Delete All',
      uiRemovingCate = 'Removing Category',
      uiItemFoundWhenDeletingCate = 'There is an Item in this Category. Remove this Category would delete all its Items.\nContinue?',
      uiItemsFoundWhenDeletingCate = 'Items in this Category. Remove this Category would delete all its Items.\nContinue?';

  //unapply_all_mods
  String uiSuccessfullyRemovedTheseMods = 'Successfully removed these mods from the game';

  //paths_loader
  String uiPso2binFolderNotFoundSelect = 'pso2_bin folder not found. Select it now?\nSelecting "Exit" would close the app',
      uiSelectPso2binFolderPath = 'Select \'pso2_bin\' folder path',
      uiMMFolderNotFound = 'Mod Manager Folder not found',
      uiSelectPathToStoreMMFolder =
          'Select a path to store your mods?\nSelecting "No" would create a folder named "PSO2 Mod Manager" inside "C:" drive\nNote: This folder will store your mods and other settings',
      uiSelectAFolderToStoreMMFolder = 'Select a folder to store Mod Manager folder',
      uiCurrentPath = 'Current path',
      uiReselect = 'Reselect',
      uiMMPathReselectNoteCurrentPath = 'Note: This folder stores mods and backups\n\nCurrent path:';

  //applied_mods_checking_page
  String uiCheckingAppliedMods = 'Checking Applied Mods',
      uiErrorWhenCheckingAppliedMods = 'Error when checking applied mod files',
      uiReappliedModsAfterChecking = 'The mod files below have been unapplied from the game',
      uireApplyingModFiles = 'Attempting to re-apply these files below',
      uiDontReapplyRemoveFromAppliedList = 'Do not re-apply and remove from Applied Mods List',
      uiReapply = 'Re-apply these mod files to the game';

  //applied_mods_loading_page
  String uiLoadingAppliedMods = 'Loading Applied Mods', uiErrorWhenLoadingAppliedMods = 'Error when loading applied mod files';

  //mod_set_loading_page
  String uiLoadingModSets = 'Loading Mod Sets', uiErrorWhenLoadingModSets = 'Error when loading Mod Sets';

  //mod_loading_page
  String uiLoadingMods = 'Loading Mods', uiErrorWhenLoadingMods = 'Error when loading mod files', uiSkipStartupIconFectching = 'Skip startup item icons fetching';

  //path_loading_page
  String uiLoadingPaths = 'Loading Paths', uiErrorWhenLoadingPaths = 'Error when loading paths';

  //preview Image diaglog
  String uiPrevious = 'Previous', uiNext = 'Next', uiAutoPlay = 'Auto Play', uiStopAutoPlay = 'Stop Auto Play';

  //cate_mover
  String uiMovingCategory = 'Moving Category', uiSelectACategoryGroupBelowToMove = 'Select a Category Group below to move', uiCategory = 'Category', uiCategories = 'Categories';

  //startup item icons popup
  String uiModsLoader = 'Mods Loader', uiAutoFetchItemIcons = 'Automatically fetch missing item icons on startup?', uiOneIconEachItem = 'One icon for each item', uiFetchAll = 'Fetch All';

//mods_swapper_homepage
  String uiChooseAVariantFoundBellow = 'Choose a variant found bellow',
      uiChooseAnItemBellowToSwap = 'Choose an item below to swap',
      uiSearchSwapItems = 'Search items',
      uiReplaceNQwithHQ = 'Replace LQ ices with HQ',
      uiSwapAllFilesInsideIce = 'Copy all files to destination ices',
      uiRemoveUnmatchingFiles = 'Remove extra files inside swapped ices',
      uiSwap = 'Swap',
      uiNoteModsMightNotWokAfterSwapping = 'Note: Some items might not work right after swapping, some might require cmx editing. Use at your own risk',
      uiItemID = 'Item ID',
      uiAdjustedID = 'Adjusted ID',
      uiSwapToIdleMotion = 'Swap to Idle Motions',
      uiSwappingQueue = 'Swapping Queue',
      uiClearQueue = 'Clear Queue',
      uiAddToQueue = 'Add To Queue',
      uiItemsToSwap = 'Items To Swap';

  //mod_swapper_swappage
  String uiNoMatchingIceFoundToSwap = 'No matching ice files found to swap item',
      uiSwappingItem = 'Swapping Item',
      uiErrorWhenSwapping = 'Error when swapping item',
      uiSuccessfullySwapped = 'Successfully Swapped',
      uiAddToModManager = 'Add to Mod Manager',
      uiFailedToSwap = 'Failed To Swap',
      uiUnableToSwapTheseFilesBelow = 'Unable to swap these files below';

  //mods_swapper_data_loader
  String uiLoadingItemRefSheetsData = 'Loading item reference sheets data',
      uiErrorWhenLoadingItemRefSheets = 'Error when loading item reference sheets data',
      uiFetchingItemInfo = 'Fetching item info',
      uiErrorWhenFetchingItemInfo = 'Error when fetching item info',
      uiItemCategoryNotFound = 'Item Category Not Found';

  //mods_swapper_popup
  String uiExperimental = 'Experimental';

  //items_swapper_homepage
  String uiChooseAnItemBelow = 'Choose an item below';

  //items_swapper_popup
  String uiItemCategories = 'Item categories';

  //patch_item_list_loading_page
  String uiFetchingItemPatchListsFromServers = 'Fetching item patch lists from servers\n(Might take a while)',
      uiErrorWhenTryingToFetchingItemPatchListsFromServers = 'Error when trying to fetching item patch lists from servers';

  //mods_adder_homepage
  String uiDuplicateModsInside = 'Duplicate mods inside',
      uiRenameThis = 'Rename this',
      uiClickToRename = 'Click to rename ',
      uiDuplicatedMod = ' duplicated mod',
      uiDuplicatedMods = ' duplicated mods',
      uiGroupSameItemVariants = 'Group Variants',
      uiAddFolders = 'Add Folders',
      uiAddFiles = 'Add Files';

  //new_profile_name.dart
  String uiNewProfileName = 'New profile name';

  //apply_all_available_mods
  String uiApplyingAllAvailableMods = 'Applying all available mods', uiLocatingOriginalFiles = 'Locating original files', uiErrorWhenLocatingOriginalFiles = 'Error when locating original files';

  //changelog_dialog.dart
  String uiPatchNotes = 'Patch Notes',
      uiMMUpdate = 'PSO2NGS Mod Manager Update',
      uiMMUpdateSuccess = 'Your Mod Manager is up to date',
      uiDownloadingUpdate = 'Downloading Update',
      uiDownloadingUpdateError = 'Downloading Update Error',
      uiGoToDownloadPage = 'Go to download page',
      uiGitHubPage = 'GitHub Page';

  //mods_boundary_edit.dart
  String uiBoundaryRadiusModification = 'Bounding Radius Modification',
      uiIndexingFiles = 'Indexing files',
      uispaceFoundExcl = ' found!',
      uiMatchingFilesFound = 'Matching files found',
      uiExtractingFiles = 'Extracting files',
      uiReadingspace = 'Reading ',
      uiEditingBoundaryRadiusValue = 'Editing bounding radius value',
      uiPackingFiles = 'Packing files',
      uiReplacingModFiles = 'Replacing mod files',
      uiAllDone = 'All done',
      uiMakeSureToReapplyThisMod = 'Make sure to re-apply this mod',
      uiBoundaryRadiusValueNotFound = 'Bounding radius value not found',
      uiNoAqpFileFound = 'No .aqp file found',
      uiNoMatchingFileFound = 'No matching file found',
      uiOnlyBasewearsAndSetwearsCanBeModified = 'Only Basewears and Setwears can be modified';

  //vital_gauge_swapper_homepage.dart
  String uiCustomBackgrounds = 'Custom Backgrounds',
      uiHoldToDeleteThisBackground = 'Hold to delete this background',
      uiOpenInFileExplorer = 'Open in File Explorer',
      uiCreateBackground = 'Create New Background',
      uiSwappedAvailableBackgrounds = 'Swapped - Available Backgrounds',
      uiHoldToRestoreThisBackgroundToItsOriginal = 'Hold to restore this background to its original',
      uiRestoreAll = 'Hold To Restore All',
      uiCroppedImageName = 'Cropped Image Name',
      uiSaveCroppedArea = 'Save Cropped Area',
      uiOverwriteImage = 'Overwite Image',
      uiVitalGaugeBackGroundsInstruction =
          'Create a new background with the Create button bellow\nThen drag a background from "Custom Backgrounds" and drop onto a desired background in "Swapped - Available Backgrounds" to replace';

  //applied_vital_gauge_checking_page.dart
  String uicheckingReplacedVitalGaugeBackgrounds = 'Checking replaced Vital Gauge backgrounds',
      uierrorWhenCheckingReplacedVitalGaugeBackgrounds = 'Error when checking replaced Vital Gauge backgrounds',
      uiReappliedVitalGaugesAfterChecking = 'The backgrounds below have been automatically re-applied to the game';

  //dotnet_check.dart
  String uiRequiredDotnetRuntimeMissing = 'Required .NET Runtime Missing',
      uiRequiresDotnetRuntimeToWorkProperly = 'PSO2NGS Mod Manager requires .NET Runtime 6.0 or later to function properly',
      uiYourDotNetVersions = 'Your .NET Runtime versions',
      uiUseButtonBelowToGetDotnet = 'Use the button below to get and install the required .NET Runtime',
      uiGetDotnetRuntime6 = 'Get .NET Runtime 6.0';

  //og_file_perm_check.dart
  String uiNoGamedataFound = 'No game data found',
      uiNoGameDataFoundMessage = 'Could not locate files inside pso2_bin data folder.\nThis could be a permission issue, please restart the app and run it as administrator or reselect pso2_bin path';

  //mod_set_functions.dart
  String uiDuplicatesFoundInTheCurrentSet = 'Duplicates found in the current set',
      uiReplaceAll = 'Replace All',
      uiReplaceDuplicateFilesOnly = 'Replace duplicate files only',
      uiNewModSet = "New Mod Set",
      uiCreateAndAddModsToThisSet = "Create and add mods to this set",
      uiAddNewSet = "Add New Set";

  //mods_rename_functions.dart
  String uiEnterNewName = 'Enter New Name';

  factory TranslationText.fromJson(Map<String, dynamic> json) => _$TranslationTextFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationTextToJson(this);
}

// TranslationText defaultUILangLoader() {
//   return TranslationText();
// }
