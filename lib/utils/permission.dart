import 'package:permission_handler/permission_handler.dart';

Future<bool> getStoragePermission() async {
  PermissionStatus status = await Permission.manageExternalStorage.status;
  print(status);

  if(status.isRestricted) {
    status = await Permission.manageExternalStorage.request();
  }

  return status.isGranted;
}

Future<bool> getLocationPermission() async {
  bool status = await Permission.location.isGranted;

  if(!status) {
    PermissionStatus requestStatus = await Permission.location.request();
    status = requestStatus.isGranted;
  }

  return status;
}

