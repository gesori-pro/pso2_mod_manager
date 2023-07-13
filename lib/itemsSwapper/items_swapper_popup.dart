import 'dart:io';

import 'package:card_banner/card_banner.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pso2_mod_manager/itemsSwapper/items_swapper_data_loader.dart';
import 'package:pso2_mod_manager/loaders/language_loader.dart';
import 'package:pso2_mod_manager/state_provider.dart';

String fromItemName = '';
String toItemName = '';

List<String> swapCategoriesF = [
  'Accessories',
  'Basewears',
  'Body Paints',
  'Cast Arm Parts',
  'Cast Body Parts',
  'Cast Leg Parts',
  'Costumes',
  'Emotes',
  'Eyes',
  'Face Paints',
  'Hairs',
  'Innerwears',
  'Motions',
  'Outerwears',
  'Setwears'
];

String selectedCategoryF = swapCategoriesF[1];

void itemsSwapperDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
            backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
            contentPadding: const EdgeInsets.all(5),
            content: CardBanner(
              text: curLangText!.uiExperimental,
              color: Colors.red,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              position: CardBannerPosition.TOPRIGHT,
              padding: 2,
              edgeSize: 0,
              child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.height, child: const ItemsSwapperDataLoader()),
            ));
      });
}

Future<void> itemsSwapperCategorySelect(context) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
                backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
                titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
                title: const Text('Select a category', style: TextStyle(fontWeight: FontWeight.w700)),
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
                content: SizedBox(
                  width: 400,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    buttonStyleData: ButtonStyleData(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    iconStyleData: const IconStyleData(iconSize: 15),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    isDense: true,
                    items: swapCategoriesF
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        //fontSize: 14,
                                        //fontWeight: FontWeight.bold,
                                        //color: Colors.white,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )))
                        .toList(),
                    value: selectedCategoryF,
                    onChanged: (value) async {
                      selectedCategoryF = value.toString();

                      setState(() {});
                    },
                  )),
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
                        itemsSwapperDialog(context);
                      },
                      child: Text(curLangText!.uiNext))
                ]);
          }));
}
