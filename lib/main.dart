import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'datos/base_datos.dart';
import 'datos/repositorio_productos.dart';
import 'datos/repositorio_ventas.dart';
import 'presentacion/caja_viewmodel.dart';
import 'presentacion/pantalla_caja.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // En escritorio sqflite necesita la versión FFI.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final db = await BaseDatos.abrir(); // composition root
  final productos = RepositorioProductos(db);
  await productos.sembrarEjemplos();
  runApp(MaterialApp(
    title: 'Punto de Venta Dolores',
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
    home: PantallaCaja(vm: CajaViewModel(productos, RepositorioVentas(db))),
  ));
}
