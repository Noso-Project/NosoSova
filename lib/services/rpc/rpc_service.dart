import 'dart:developer';

import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Class used to set up all the routing for your server
class Service {
  final Repositories repositories;

  Service(this.repositories);

  // The handler/middleware that will be used by the server, all the routing for the server will be implemented here.
  Handler get handler {
    final router = Router();

    // GET
    // Replies with the text inserted in the path, example: http://localhost:8080/say-hi/Filipe will prompt "hi Filipe".
    router.get('/say-hi/<name>', (Request request, String name) {
      return Response.ok('hi $name');
    });

    // GET
    // You can use regex to limit the capture of the path arguments, in this case the userId param needs to be only digits. Note how you can also used 'async'
    // With the server running try to open http://localhost:8080/user/132 and http://localhost:8080/user/a123
    router.get('/user/<userId|[0-9]+>', (Request request) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return Response.ok('_o/');
    });

    // You can also embed other routers, in this case it will help organizer your routers
    // Note: This needs be before the catch 'router.all' that follows
    router.mount('/api/', Api().router);

    // A catch all of the non implemented routing, useful for showing 404 page now found
    // With the server running try to open http://localhost:8080/abc
    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}
