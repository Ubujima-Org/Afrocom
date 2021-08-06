import 'dart:io';
import 'package:afrocom/app/constants/appwrite.credentials.dart';
import 'package:afrocom/app/constants/database.credentials.dart';
import 'package:afrocom/core/models/post.model.dart';
import 'package:afrocom/core/models/signeduser.model.dart';
import 'package:afrocom/meta/utilities/snackbar.utility.dart';
import 'package:afrocom/meta/views/authentication/login/login.exports.dart';
import 'package:appwrite/appwrite.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  final _logger = Logger();
  static DatabaseService? _instance;
  late Client _client;
  late Database _database;

  DatabaseService._initialize() {
    _client = Client(endPoint: AppwriteCredentials.AppwriteLocalEndpoint)
        .setProject(AppwriteCredentials.AppwriteLocalProjectID)
        .setSelfSigned();
    _database = Database(_client);
  }
  static DatabaseService get createInstance {
    if (_instance == null) {
      _instance = DatabaseService._initialize();
    }
    return _instance!;
  }

  Future submitUserData(
      {required BuildContext context, required SignedUser signedUser}) async {
    print("Submitting data");
    try {
      var response = await _database.createDocument(
          collectionId: "610d7c664edbe",
          data: signedUser.toJson(),
          read: ['*'],
          write: ['*']);
      print(response.data);
      var resStatusCode = response.statusCode;
      print("Database status : $resStatusCode");
      if (resStatusCode == 201) {
        print("Data added");
      }
    } on SocketException catch (error) {
      _logger.i(error.message);
    } on AppwriteException catch (error) {
      _logger.i(error.response);
      _logger.i(error.code);
      _logger.i(error.message);
      var errorCode = error.code;
      switch (errorCode) {
        case 429: //! Too many requests
          SnackbarUtility.showSnackbar(
              context: context, message: "Server error, Try again!");
          break;
        case 400: //! Bad structure. Invalid document structure: Unknown properties are not allowed.
          SnackbarUtility.showSnackbar(
              context: context, message: "Something went wrong, Try again");
      }
    } catch (error) {
      _logger.i(error);
      SnackbarUtility.showSnackbar(
          context: context, message: "Something went wrong, Try again");
    }
  }

  //! Create new post
  Future createPost({required BuildContext context, required Post post}) async {
    try {
      var response = await _database.createDocument(
          collectionId: DatabaseCredentials.PostCollectionID,
          data: post.toJson(),
          read: ["*"],
          write: ["*"]);
      _logger.i(response);
    } on SocketException catch (error) {
      _logger.i(error);
    } on AppwriteException catch (error) {
      _logger.i(error.response);
      SnackbarUtility.showSnackbar(
          context: context, message: "No internet connection");
      var errorCode = error.code;
      switch (errorCode) {
        case 429: //! Too many requests
          SnackbarUtility.showSnackbar(
              context: context, message: "Server error, Try again!");
          break;
        case 400: //! Bad structure. Invalid document structure: Unknown properties are not allowed.
          SnackbarUtility.showSnackbar(
              context: context, message: "Something went wrong, Try again");
      }
    } catch (error) {
      _logger.i(error);
    }
  }

  Future<List<Post>?> fetchPosts({required BuildContext context}) async {
    try {
      var postsData = await _database.listDocuments(
          collectionId: DatabaseCredentials.PostCollectionID);
      if (postsData.data != null) {
        List posts = postsData.data['documents'];
        List<Post> post = posts.map((data) => new Post.fromJson(data)).toList();
        print(post.single);
      }
    } on AppwriteException catch (error) {
      _logger.i(error.response);
      var errorCode = error.code;
      switch (errorCode) {
        case 429: //! Too many requests
          SnackbarUtility.showSnackbar(
              context: context, message: "Server error, Try again!");
          break;
        case 400: //! Bad structure. Invalid document structure: Unknown properties are not allowed.
          SnackbarUtility.showSnackbar(
              context: context, message: "Something went wrong, Try again");
      }
    } catch (error) {
      _logger.i(error);
    }
  }
}
