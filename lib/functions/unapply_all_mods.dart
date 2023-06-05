import 'dart:io';

import 'package:pso2_mod_manager/classes/mod_file_class.dart';
import 'package:pso2_mod_manager/functions/applied_list_builder.dart';
import 'package:pso2_mod_manager/functions/json_write.dart';
import 'package:pso2_mod_manager/functions/modfiles_unapply.dart';
import 'package:pso2_mod_manager/global_variables.dart';
import 'package:pso2_mod_manager/loaders/language_loader.dart';

Future<List<String>> unapplyAllMods(context) async {
  String unappliedFileNames = '';
  for (var type in appliedItemList) {
    for (var cate in type.categories) {
      for (var item in cate.items) {
        if (item.applyStatus) {
          for (var mod in item.mods) {
            if (mod.applyStatus) {
              for (var submod in mod.submods) {
                List<ModFile> allAppliedModFiles = submod.modFiles.where((element) => element.applyStatus).toList();
                String bkNotFoundFileNames = '';
                //check backups
                bool allBkFilesFound = true;
                for (var modFile in allAppliedModFiles) {
                  for (var bkFile in modFile.bkLocations) {
                    if (!File(bkFile).existsSync()) {
                      allBkFilesFound = false;
                      if (!bkNotFoundFileNames.contains(modFile.modFileName)) {
                        bkNotFoundFileNames += '${item.itemName} > ${mod.modName} > ${submod.submodName} ${modFile.modFileName}\n';
                      }
                    }
                  }
                }
                if (!allBkFilesFound) {
                  return ['${curLangText!.uiError}!', '${curLangText!.uiCouldntFindBackupFileFor}\n${bkNotFoundFileNames.trim()}'];
                }

                if (allBkFilesFound) {
                  await modFilesUnapply(context, allAppliedModFiles);
                  if (submod.applyStatus) {
                    unappliedFileNames += '${item.itemName} > ${mod.modName} > ${submod.submodName}\n';
                  }
                  submod.applyStatus = false;
                  submod.applyDate = DateTime(0);
                  previewImages.clear();
                  //videoPlayer.remove(0);
                  previewModName = '';

                  if (mod.submods.where((element) => element.applyStatus).isEmpty) {
                    mod.applyStatus = false;
                    mod.applyDate = DateTime(0);
                  }
                  if (item.mods.where((element) => element.applyStatus).isEmpty) {
                    item.applyStatus = false;
                    item.applyDate = DateTime(0);
                  }

                  appliedItemList = await appliedListBuilder(moddedItemsList);
                  saveModdedItemListToJson();
                }
              }
            }
          }
        }
      }
    }
  }

  return ['${curLangText!.uiSuccess}!', '${curLangText!.uiSuccessfullyRemovedTheseMods}}\n${unappliedFileNames.trim()}'];
}
