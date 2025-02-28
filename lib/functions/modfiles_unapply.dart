// import 'dart:io';

// import 'package:pso2_mod_manager/classes/mod_file_class.dart';
// import 'package:pso2_mod_manager/filesDownloader/ice_files_download.dart';
// import 'package:pso2_mod_manager/functions/applied_list_builder.dart';
// import 'package:pso2_mod_manager/functions/json_write.dart';
// import 'package:pso2_mod_manager/global_variables.dart';
// import 'package:pso2_mod_manager/loaders/paths_loader.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path/path.dart' as p;

// Future<List<ModFile>> modFilesUnapply(context, List<ModFile> modFiles) async {
//   //apply mods
//   List<ModFile> unappliedModFiles = [];
//   List<String> unapplyModFileDataPaths = [];
//   for (var modFile in modFiles) {
//     for (var ogFilePath in modFile.ogLocations) {
//       String dataFilePath = ogFilePath.replaceFirst(Uri.file('$modManPso2binPath/').toFilePath(), '').trim();
//       unapplyModFileDataPaths.add(dataFilePath);
//     }
//     List<String> restoredFiles = [];
//     if (unapplyModFileDataPaths.isNotEmpty) {
//       restoredFiles = await downloadIceFromOfficial(unapplyModFileDataPaths);
//     }
//     if (restoredFiles.isNotEmpty) {
//       modFile.ogLocations.removeWhere((element) => restoredFiles.contains(element.replaceFirst(Uri.file('$modManPso2binPath/').toFilePath(), '')));
//       for (var bkPath in modFile.bkLocations) {
//         if (File(bkPath).existsSync()) {
//           File(bkPath).deleteSync();
//           if (bkPath.contains('win32reboot_na') && Directory(p.dirname(bkPath)).listSync(recursive: true).whereType<File>().isEmpty) {
//               Directory(p.dirname(bkPath)).deleteSync(recursive: true);
//             }
//         }
//       }
//       modFile.bkLocations.removeWhere((element) => restoredFiles.contains(element.replaceFirst(Uri.file(modManBackupsDirPath).toFilePath(), 'data')));
//     }
//     if (modFile.ogLocations.isNotEmpty) {
//       List<String> ogPathsToRemove = [];
//       for (var ogPath in modFile.ogLocations) {
//         String matchingBkPath = modFile.bkLocations.firstWhere(
//           (element) =>
//               element.replaceFirst(modManBackupsDirPath, '') == ogPath.replaceFirst(Uri.file('$modManPso2binPath/data').toFilePath(), '') &&
//               unapplyModFileDataPaths.contains(element.replaceFirst(modManBackupsDirPath, 'data')),
//           orElse: () => '',
//         );
//         if (matchingBkPath.isNotEmpty && File(matchingBkPath).existsSync()) {
//           File restoredFile = File('');
//           try {
//             restoredFile = await File(matchingBkPath).copy(ogPath);
//           } catch (e) {
//             if (File(ogPath).existsSync()) {
//               File(ogPath).deleteSync();
//             }
//             restoredFile = await File(matchingBkPath).copy(ogPath);
//           }
//           if (restoredFile.path == ogPath) {
//             File(matchingBkPath).deleteSync();
//             if (matchingBkPath.contains('win32reboot_na') && Directory(p.dirname(matchingBkPath)).listSync(recursive: true).whereType<File>().isEmpty) {
//               Directory(p.dirname(matchingBkPath)).deleteSync(recursive: true);
//             }
//             modFile.bkLocations.remove(matchingBkPath);
//             ogPathsToRemove.add(ogPath);
//           }
//         }
//       }
//       modFile.ogLocations.removeWhere((element) => ogPathsToRemove.contains(element));
//     }
//     if (modFile.bkLocations.isEmpty && modFile.ogLocations.isEmpty) {
//       modFile.ogMd5s.clear();
//       modFile.applyDate = DateTime(0);
//       //add to result if applied then unapplied
//       if (modFile.applyStatus) {
//         unappliedModFiles.add(modFile);
//       }
//       modFile.applyStatus = false;
//     }
//   }

//   //final restoredFileNames = restoredFiles.map((e) => p.basename(e)).toList();
//   // final restoredOGFilePaths = restoredFiles.map((e) => Uri.file('$modManPso2binPath/$e').toFilePath()).toList();

//   // for (var modFile in modFiles) {
//   //   modFile.ogLocations.removeWhere((element) => restoredOGFilePaths.contains(element));

//   //   if (modFile.ogLocations.isEmpty) {
//   //     //remove backup files
//   //     List<String> bkPathsToRemove = [];
//   //     for (var filePath in modFile.bkLocations) {
//   //       File bkFile = File(filePath);
//   //       if (bkFile.existsSync()) {
//   //         bkFile.deleteSync();
//   //         bkPathsToRemove.add(filePath);
//   //         if (filePath.contains('win32reboot_na') && Directory(p.dirname(filePath)).listSync(recursive: true).whereType<File>().isEmpty) {
//   //           Directory(p.dirname(filePath)).deleteSync(recursive: true);
//   //         }
//   //       }
//   //     }
//   //     modFile.bkLocations.removeWhere((element) => bkPathsToRemove.contains(element));
//   //   } else {
//   //     List<String> ogPathsToRemove = [];
//   //     for (var ogPath in modFile.ogLocations) {
//   //       String matchingBkPath = modFile.bkLocations.firstWhere(
//   //         (element) =>
//   //             element.replaceFirst(modManBackupsDirPath, '') == ogPath.replaceFirst(Uri.file('$modManPso2binPath/data').toFilePath(), '') &&
//   //             unapplyModFileDataPaths.contains(element.replaceFirst(modManBackupsDirPath, 'data')),
//   //         orElse: () => '',
//   //       );
//   //       if (matchingBkPath.isNotEmpty && File(matchingBkPath).existsSync()) {
//   //         File restoredFile = File('');
//   //         try {
//   //           restoredFile = await File(matchingBkPath).copy(ogPath);
//   //         } catch (e) {
//   //           if (File(ogPath).existsSync()) {
//   //             File(ogPath).deleteSync();
//   //           }
//   //           restoredFile = await File(matchingBkPath).copy(ogPath);
//   //         }
//   //         if (restoredFile.path == ogPath) {
//   //           File(matchingBkPath).deleteSync();
//   //           if (matchingBkPath.contains('win32reboot_na') && Directory(p.dirname(matchingBkPath)).listSync(recursive: true).whereType<File>().isEmpty) {
//   //             Directory(p.dirname(matchingBkPath)).deleteSync(recursive: true);
//   //           }
//   //           modFile.bkLocations.remove(matchingBkPath);
//   //           ogPathsToRemove.add(ogPath);
//   //         }
//   //       }
//   //     }
//   //     modFile.ogLocations.removeWhere((element) => ogPathsToRemove.contains(element));
//   //   }

//   //   if (modFile.bkLocations.isEmpty && modFile.ogLocations.isEmpty) {
//   //     modFile.ogMd5s.clear();
//   //     modFile.applyDate = DateTime(0);
//   //     //add to result if applied then unapplied
//   //     if (modFile.applyStatus) {
//   //       unappliedModFiles.add(modFile);
//   //     }
//   //     modFile.applyStatus = false;
//   //   }
//   // }
//   saveModdedItemListToJson();
//   appliedItemList = await appliedListBuilder(moddedItemsList);

//   return unappliedModFiles;
// }

// Future<List<ModFile>> modFilesUnapply(context, List<ModFile> modFiles) async {
//   //apply mods
//   List<ModFile> unappliedModFiles = [];
//   List<String> unapplyModFileDataPaths = [];
//   for (var modFile in modFiles) {
//     //check for mods that use the same file
//     bool sameModFileFound = false;
//     for (var type in appliedItemList) {
//       for (var cate in type.categories) {
//         for (var item in cate.items) {
//           if (item.applyStatus) {
//             for (var mod in item.mods) {
//               if (mod.applyStatus) {
//                 for (var submod in mod.submods) {
//                   if (submod.applyStatus) {
//                     for (var file in submod.modFiles) {
//                       if (file.applyStatus) {
//                         if (file.modFileName == modFile.modFileName && file.location != modFile.location) {
//                           sameModFileFound = true;
//                           break;
//                         }
//                       }
//                     }
//                   }
//                 }
//               }
//             }
//           }
//         }
//       }
//     }

//     if (!sameModFileFound) {
//       for (var ogFilePath in modFile.ogLocations) {
//         String dataFilePath = ogFilePath.replaceFirst(Uri.file('$modManPso2binPath/').toFilePath(), '').trim();
//         unapplyModFileDataPaths.add(dataFilePath);
//       }
//     }
//   }

//   List<String> restoredFiles = [];
//   if (unapplyModFileDataPaths.isNotEmpty) {
//     restoredFiles = await downloadIceFromOfficial(unapplyModFileDataPaths);
//   }
//   //final restoredFileNames = restoredFiles.map((e) => p.basename(e)).toList();
//   final restoredOGFilePaths = restoredFiles.map((e) => Uri.file('$modManPso2binPath/$e').toFilePath()).toList();

//   for (var modFile in modFiles) {
//     modFile.ogLocations.removeWhere((element) => restoredOGFilePaths.contains(element));

//     if (modFile.ogLocations.isEmpty) {
//       //remove backup files
//       List<String> bkPathsToRemove = [];
//       for (var filePath in modFile.bkLocations) {
//         File bkFile = File(filePath);
//         if (bkFile.existsSync()) {
//           bkFile.deleteSync();
//           bkPathsToRemove.add(filePath);
//           if (filePath.contains('win32reboot_na') && Directory(p.dirname(filePath)).listSync(recursive: true).whereType<File>().isEmpty) {
//             Directory(p.dirname(filePath)).deleteSync(recursive: true);
//           }
//         }
//       }
//       modFile.bkLocations.removeWhere((element) => bkPathsToRemove.contains(element));
//     } else {
//       List<String> ogPathsToRemove = [];
//       for (var ogPath in modFile.ogLocations) {
//         String matchingBkPath = modFile.bkLocations.firstWhere(
//           (element) =>
//               element.replaceFirst(modManBackupsDirPath, '') == ogPath.replaceFirst(Uri.file('$modManPso2binPath/data').toFilePath(), '') &&
//               unapplyModFileDataPaths.contains(element.replaceFirst(modManBackupsDirPath, 'data')),
//           orElse: () => '',
//         );
//         if (matchingBkPath.isNotEmpty && File(matchingBkPath).existsSync()) {
//           File restoredFile = File('');
//           try {
//             restoredFile = await File(matchingBkPath).copy(ogPath);
//           } catch (e) {
//             if (File(ogPath).existsSync()) {
//               File(ogPath).deleteSync();
//             }
//             restoredFile = await File(matchingBkPath).copy(ogPath);
//           }
//           if (restoredFile.path == ogPath) {
//             File(matchingBkPath).deleteSync();
//             if (matchingBkPath.contains('win32reboot_na') && Directory(p.dirname(matchingBkPath)).listSync(recursive: true).whereType<File>().isEmpty) {
//               Directory(p.dirname(matchingBkPath)).deleteSync(recursive: true);
//             }
//             modFile.bkLocations.remove(matchingBkPath);
//             ogPathsToRemove.add(ogPath);
//           }
//         }
//       }
//       modFile.ogLocations.removeWhere((element) => ogPathsToRemove.contains(element));
//     }

//     if (modFile.bkLocations.isEmpty && modFile.ogLocations.isEmpty) {
//       modFile.ogMd5s.clear();
//       modFile.applyDate = DateTime(0);
//       //add to result if applied then unapplied
//       if (modFile.applyStatus) {
//         unappliedModFiles.add(modFile);
//       }
//       modFile.applyStatus = false;
//     }
//   }
//   saveModdedItemListToJson();
//   appliedItemList = await appliedListBuilder(moddedItemsList);

//   return unappliedModFiles;
// }


// Future<List<ModFile>> modFilesUnapply(context, List<ModFile> modFiles) async {
//   //apply mods
//   List<ModFile> unappliedModFiles = [];
//   for (var modFile in modFiles) {
//     modFile = await modFileUnapply(modFile);
//     modFile.ogMd5s.clear();
//     modFile.bkLocations.clear();
//     modFile.ogLocations.clear();
//     modFile.applyDate = DateTime(0);
//     modFile.applyStatus = false;
//     unappliedModFiles.add(modFile);
//   }

//   return unappliedModFiles;
// }


