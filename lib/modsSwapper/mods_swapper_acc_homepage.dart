import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pso2_mod_manager/classes/csv_ice_file_class.dart';
import 'package:pso2_mod_manager/classes/item_class.dart';
import 'package:pso2_mod_manager/classes/sub_mod_class.dart';
import 'package:pso2_mod_manager/global_variables.dart';
import 'package:pso2_mod_manager/loaders/language_loader.dart';
import 'package:pso2_mod_manager/loaders/paths_loader.dart';
import 'package:pso2_mod_manager/main.dart';
import 'package:pso2_mod_manager/modsSwapper/mods_swapper_acc_swappage.dart';
import 'package:pso2_mod_manager/modsSwapper/mods_swapper_popup.dart';
import 'package:pso2_mod_manager/state_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController swapperSearchTextController = TextEditingController();
List<CsvAccessoryIceFile> toAccSearchResults = [];
CsvAccessoryIceFile? selectedFromAccCsvFile;
CsvAccessoryIceFile? selectedToAccCsvFile;
String fromAccItemId = '';
String toAccItemId = '';
List<String> fromAccItemAvailableIces = [];
List<String> toAccItemAvailableIces = [];

class ModsSwapperAccHomePage extends StatefulWidget {
  const ModsSwapperAccHomePage({super.key, required this.fromItem, required this.fromSubmod});

  final Item fromItem;
  final SubMod fromSubmod;

  @override
  State<ModsSwapperAccHomePage> createState() => _ModsSwapperAccHomePageState();
}

class _ModsSwapperAccHomePageState extends State<ModsSwapperAccHomePage> {
  @override
  void initState() {
    //clear
    if (Directory(modManSwapperFromItemDirPath).existsSync()) {
      Directory(modManSwapperFromItemDirPath).deleteSync(recursive: true);
    }
    if (Directory(modManSwapperToItemDirPath).existsSync()) {
      Directory(modManSwapperToItemDirPath).deleteSync(recursive: true);
    }
    if (Directory(modManSwapperOutputDirPath).existsSync()) {
      Directory(modManSwapperOutputDirPath).deleteSync(recursive: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //create temp dirs
    Directory(modManSwapperDirPath).createSync(recursive: true);

    //create
    Directory(modManSwapperOutputDirPath).createSync(recursive: true);

    //fetch icons
    final iceNamesFromSubmod = widget.fromSubmod.getModFileNames();
    final fromItemCsvData = csvAccData.where((element) => iceNamesFromSubmod.contains(element.hqIceName) || iceNamesFromSubmod.contains(element.nqIceName)).toList();
    List<List<String>> csvInfos = [];
    int itemIdLength = 0;
    for (var csvItemData in fromItemCsvData) {
      final data = csvItemData.getDetailedList().where((element) => element.split(': ').last.isNotEmpty).toList();
      final availableModFileData = data.where((element) => iceNamesFromSubmod.contains(element.split(': ').last)).toList();
      csvInfos.add(availableModFileData);
      if (itemIdLength == 0) {
        itemIdLength = csvItemData.id.toString().length;
      }
    }

    //availableAccCsvData = availableAccCsvData.where((element) => element.id.toString().length == itemIdLength).toList();

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            children: [
              RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    'MODS SWAP',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: constraints.maxHeight / 12),
                  )),
              VerticalDivider(
                width: 10,
                thickness: 2,
                indent: 5,
                endIndent: 5,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //from
                          Expanded(
                              child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                                child: ListTile(
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2, right: 10),
                                        child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: Theme.of(context).hintColor, width: 1),
                                            ),
                                            child: widget.fromItem.icons.first.contains('assets/img/placeholdersquare.png')
                                                ? Image.asset(
                                                    'assets/img/placeholdersquare.png',
                                                    filterQuality: FilterQuality.none,
                                                    fit: BoxFit.fitWidth,
                                                  )
                                                : Image.file(
                                                    File(widget.fromItem.icons.first),
                                                    filterQuality: FilterQuality.none,
                                                    fit: BoxFit.fitWidth,
                                                  )),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.fromItem.category,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                            ),
                                            Text(widget.fromItem.itemName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                            Text('${widget.fromSubmod.modName} > ${widget.fromSubmod.submodName}')
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 5,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(curLangText!.uiChooseAVariantFoundBellow),
                                    ),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                        color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                                        child: ScrollbarTheme(
                                          data: ScrollbarThemeData(
                                            thumbColor: MaterialStateProperty.resolveWith((states) {
                                              if (states.contains(MaterialState.hovered)) {
                                                return Theme.of(context).textTheme.displaySmall?.color?.withOpacity(0.7);
                                              }
                                              return Theme.of(context).textTheme.displaySmall?.color?.withOpacity(0.5);
                                            }),
                                          ),
                                          child: ListView.builder(
                                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                              shrinkWrap: true,
                                              //physics: const PageScrollPhysics(),
                                              itemCount: fromItemCsvData.length,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                                  child: RadioListTile(
                                                    shape:
                                                        RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                                    value: fromItemCsvData[i],
                                                    groupValue: selectedFromAccCsvFile,
                                                    title: Text(modManCurActiveItemNameLanguage == 'JP' ? fromItemCsvData[i].jpName : fromItemCsvData[i].enName),
                                                    subtitle: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [for (int line = 0; line < csvInfos[i].length; line++) Text(csvInfos[i][line])],
                                                    ),
                                                    onChanged: (CsvAccessoryIceFile? currentItem) {
                                                      //print("Current ${moddedItemsList[i].groupName}");
                                                      selectedFromAccCsvFile = currentItem!;
                                                      fromAccItemAvailableIces = csvInfos[i];
                                                      fromAccItemId = selectedFromAccCsvFile!.id.toString();
                                                      //set infos
                                                      if (selectedToAccCsvFile != null) {
                                                        toAccItemAvailableIces.clear();
                                                        List<String> selectedToItemIceList = selectedToAccCsvFile!.getDetailedList();
                                                        for (var line in selectedToItemIceList) {
                                                          if (fromAccItemAvailableIces.where((element) => element.split(': ').first == line.split(': ').first).isNotEmpty) {
                                                            toAccItemAvailableIces.add(line);
                                                          }
                                                        }
                                                      }
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 25,
                            ),
                          ),
                          //to
                          Expanded(
                              child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                                child: SizedBox(
                                    height: 92,
                                    child: ListTile(
                                      minVerticalPadding: 15,
                                      title: Text(curLangText!.uiChooseAnItemBellowToSwap),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: TextField(
                                            controller: swapperSearchTextController,
                                            maxLines: 1,
                                            textAlignVertical: TextAlignVertical.center,
                                            decoration: InputDecoration(
                                                hintText: curLangText!.uiSearchSwapItems,
                                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                                isCollapsed: true,
                                                isDense: true,
                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                                                suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 28),
                                                suffixIcon: InkWell(
                                                  onTap: swapperSearchTextController.text.isEmpty
                                                      ? null
                                                      : () {
                                                          swapperSearchTextController.clear();
                                                          setState(() {});
                                                        },
                                                  child: Icon(
                                                    swapperSearchTextController.text.isEmpty ? Icons.search : Icons.close,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                constraints: BoxConstraints.tight(const Size.fromHeight(26)),
                                                // Set border for enabled state (default)
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1, color: Theme.of(context).hintColor),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                // Set border for focused state
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
                                                  borderRadius: BorderRadius.circular(10),
                                                )),
                                            onChanged: (value) async {
                                              toAccSearchResults = availableAccCsvData
                                                  .where((element) => modManCurActiveItemNameLanguage == 'JP'
                                                      ? element.jpName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase()) ||
                                                          element.hqIceName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase()) ||
                                                          element.nqIceName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase())
                                                      : element.enName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase()) ||
                                                          element.hqIceName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase()) ||
                                                          element.nqIceName.toLowerCase().contains(swapperSearchTextController.text.toLowerCase()))
                                                  .toList();
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              const Divider(
                                height: 5,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          MaterialButton(
                                            height: 29,
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              final prefs = await SharedPreferences.getInstance();
                                              isReplacingNQWithHQ ? isReplacingNQWithHQ = false : isReplacingNQWithHQ = true;
                                              prefs.setBool('modsSwapperIsReplacingNQWithHQ', isReplacingNQWithHQ);
                                              setState(() {});
                                            },
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              runAlignment: WrapAlignment.center,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              spacing: 5,
                                              children: [Icon(isReplacingNQWithHQ ? Icons.check_box_outlined : Icons.check_box_outline_blank), Text(curLangText!.uiReplaceNQwithHQ)],
                                            ),
                                          ),
                                          // MaterialButton(
                                          //   height: 29,
                                          //   padding: EdgeInsets.zero,
                                          //   onPressed: () async {
                                          //     final prefs = await SharedPreferences.getInstance();
                                          //     isCopyAll ? isCopyAll = false : isCopyAll = true;
                                          //     prefs.setBool('modsSwapperIsCopyAll', isCopyAll);
                                          //     setState(() {});
                                          //   },
                                          //   child: Wrap(
                                          //     alignment: WrapAlignment.center,
                                          //     runAlignment: WrapAlignment.center,
                                          //     crossAxisAlignment: WrapCrossAlignment.center,
                                          //     spacing: 5,
                                          //     children: [Icon(isCopyAll ? Icons.check_box_outlined : Icons.check_box_outline_blank), Text(curLangText!.uiSwapAllFilesInsideIce)],
                                          //   ),
                                          // ),
                                          MaterialButton(
                                            height: 29,
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              final prefs = await SharedPreferences.getInstance();
                                              isRemoveExtras ? isRemoveExtras = false : isRemoveExtras = true;
                                              prefs.setBool('modsSwapperIsRemoveExtras', isRemoveExtras);
                                              setState(() {});
                                            },
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              runAlignment: WrapAlignment.center,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              spacing: 5,
                                              children: [Icon(isRemoveExtras ? Icons.check_box_outlined : Icons.check_box_outline_blank), Text(curLangText!.uiRemoveUnmatchingFiles)],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                          shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                          color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                                          child: ScrollbarTheme(
                                              data: ScrollbarThemeData(
                                                thumbColor: MaterialStateProperty.resolveWith((states) {
                                                  if (states.contains(MaterialState.hovered)) {
                                                    return Theme.of(context).textTheme.displaySmall?.color?.withOpacity(0.7);
                                                  }
                                                  return Theme.of(context).textTheme.displaySmall?.color?.withOpacity(0.5);
                                                }),
                                              ),
                                              child: ListView.builder(
                                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                  shrinkWrap: true,
                                                  //physics: const BouncingScrollPhysics(),
                                                  itemCount: swapperSearchTextController.text.isEmpty ? availableAccCsvData.length : toAccSearchResults.length,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                                      child: RadioListTile(
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                                        value: swapperSearchTextController.text.isEmpty ? availableAccCsvData[i] : toAccSearchResults[i],
                                                        groupValue: selectedToAccCsvFile,
                                                        title: modManCurActiveItemNameLanguage == 'JP'
                                                            ? swapperSearchTextController.text.isEmpty
                                                                ? Text(availableAccCsvData[i].jpName)
                                                                : Text(toAccSearchResults[i].jpName)
                                                            : swapperSearchTextController.text.isEmpty
                                                                ? Text(availableAccCsvData[i].enName)
                                                                : Text(toAccSearchResults[i].enName),
                                                        onChanged: (CsvAccessoryIceFile? currentItem) {
                                                          //print("Current ${moddedItemsList[i].groupName}");
                                                          selectedToAccCsvFile = currentItem!;
                                                          toItemName = modManCurActiveItemNameLanguage == 'JP' ? selectedToAccCsvFile!.jpName : selectedToAccCsvFile!.enName;
                                                          toAccItemId = selectedToAccCsvFile!.id.toString();
                                                          if (fromAccItemAvailableIces.isNotEmpty) {
                                                            toAccItemAvailableIces.clear();
                                                            List<String> selectedToItemIceList = selectedToAccCsvFile!.getDetailedList();
                                                            for (var line in selectedToItemIceList) {
                                                              if (fromAccItemAvailableIces.where((element) => element.split(': ').first == line.split(': ').first).isNotEmpty) {
                                                                toAccItemAvailableIces.add(line);
                                                              }

                                                              if (isReplacingNQWithHQ && line.split(': ').first.contains('Normal Quality')) {
                                                                toAccItemAvailableIces.add(line);
                                                              }
                                                            }
                                                          }
                                                          setState(
                                                            () {},
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(curLangText!.uiNoteModsMightNotWokAfterSwapping),
                          Wrap(
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            spacing: 5,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    swapperSearchTextController.clear();
                                    selectedFromAccCsvFile = null;
                                    selectedToAccCsvFile = null;
                                    availableAccCsvData.clear();
                                    fromAccItemId = '';
                                    toAccItemId = '';
                                    fromAccItemAvailableIces.clear();
                                    toAccItemAvailableIces.clear();
                                    csvAccData.clear();
                                    availableAccCsvData.clear();
                                    toAccSearchResults.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text(curLangText!.uiClose)),
                              ElevatedButton(
                                  onPressed: selectedFromAccCsvFile == null || selectedToAccCsvFile == null
                                      ? null
                                      : () {
                                          if (selectedFromAccCsvFile != null && selectedToAccCsvFile != null) {
                                            swapperConfirmDialog(context, widget.fromSubmod, fromAccItemId, fromAccItemAvailableIces, toAccItemId, toAccItemAvailableIces);
                                          }
                                        },
                                  child: Text(curLangText!.uiNext))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }));
  }
}

Future<void> swapperConfirmDialog(context, SubMod fromSubmod, String fromAccItemId, List<String> fromAccItemAvailableIces, String toAccItemId, List<String> toAccItemAvailableIces) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
                backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
                titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: Center(child: Text(fromSubmod.itemName, style: const TextStyle(fontWeight: FontWeight.w700)))),
                    Expanded(flex: 1, child: Center(child: Text(toItemName, style: const TextStyle(fontWeight: FontWeight.w700)))),
                  ],
                ),
                contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
                            color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [Text('${curLangText!.uiItemID}: $fromAccItemId'), for (int i = 0; i < fromAccItemAvailableIces.length; i++) Text(fromAccItemAvailableIces[i])],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
                            color: MyApp.themeNotifier.value == ThemeMode.light ? Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.7) : Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [Text('${curLangText!.uiItemID}: $toAccItemId'), for (int i = 0; i < toAccItemAvailableIces.length; i++) Text(toAccItemAvailableIces[i])],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                      child: Text(curLangText!.uiReturn),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        swapperAccSwappingDialog(context, false, fromSubmod, fromAccItemAvailableIces, toAccItemAvailableIces, toItemName);
                      },
                      child: Text(curLangText!.uiSwap))
                ]);
          }));
}
