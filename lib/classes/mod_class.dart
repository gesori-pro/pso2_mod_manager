import 'package:json_annotation/json_annotation.dart';
import 'package:pso2_mod_manager/classes/sub_mod_class.dart';

part 'mod_class.g.dart';

@JsonSerializable()
class Mod {
  Mod(this.modName, this.itemName, this.category, this.location, this.applyStatus, this.applyDate, this.position, this.isNew, this.isFavorite, this.isSet, this.setNames, this.previewImages,
      this.previewVideos, this.appliedSubMods, this.submods);
  String modName;
  String itemName;
  String category;
  String location;
  bool applyStatus;
  DateTime applyDate;
  int position;
  bool isNew;
  bool isFavorite;
  bool isSet;
  List<String> setNames;
  List<String> previewImages;
  List<String> previewVideos;
  List<SubMod> appliedSubMods;
  List<SubMod> submods;

  List<String> getModFileNames() {
    List<String> names = [];
    for (var submod in submods) {
      names.addAll(submod.getModFileNames());
    }
    return names;
  }

  List<String> getDistinctModFilePaths() {
    List<String> paths = [];
    for (var submod in submods) {
      paths.addAll(submod.getDistinctModFilePaths());
    }
    return paths;
  }

  bool getSubmodsAppliedState() {
    if (submods.where((element) => element.getModFilesAppliedState()).isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool getSubmodsIsNewState() {
    if (submods.where((element) => element.getModFilesIsNewState()).isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  factory Mod.fromJson(Map<String, dynamic> json) => _$ModFromJson(json);
  Map<String, dynamic> toJson() => _$ModToJson(this);
}
