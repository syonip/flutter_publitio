package com.learningsomethingnew.flutter_publitio;

import android.net.Uri;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.publit.publit_io.constant.CreateFileParams;
import com.publit.publit_io.constant.FilesADParams;
import com.publit.publit_io.constant.FilesDownloadParams;
import com.publit.publit_io.constant.FilesPrivacyParams;
import com.publit.publit_io.constant.FilesResolutions;
import com.publit.publit_io.constant.FilesTransformationParams;
import com.publit.publit_io.exception.PublitioExceptions;
import com.publit.publit_io.utils.APIConfiguration;
import com.publit.publit_io.utils.Publitio;
import com.publit.publit_io.utils.PublitioCallback;


import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPublitioPlugin */
public class FlutterPublitioPlugin implements MethodCallHandler {
  Publitio mPublitio;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_publitio");
    channel.setMethodCallHandler(new FlutterPublitioPlugin(channel, registrar));
  }

  private FlutterPublitioPlugin(MethodChannel channel, Registrar registrar) {
    
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "configure":
        configure(call, result);
        break;
      case "uploadFile":
        uploadFile(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
  private void uploadFile(MethodCall call, final Result result) {
    final String apiKey = call.argument("apiKey");
    final String apiSecret = call.argument("apiSecret");
    APIConfiguration.apiKey = apiKey;
    APIConfiguration.apiSecret = apiSecret;
    mPublitio = new Publitio(registrar.activity());
    result(null);
  }

  private void uploadFile(MethodCall call, final Result result) {
    final String path = call.argument("path");
    File file = new File(path);
    if (!file.exists()) {
      result.error("no_file", "File does't exist", null);
      return;
    }
    final Uri fileUri = Uri.fromFile(file);

    Map<String, String> create = new HashMap<>();
    create.put(CreateFileParams.PRIVACY, FilesPrivacyParams.PUBLIC);
    create.put(CreateFileParams.OPTION_DOWNLOAD, FilesDownloadParams.DISABLE);
    create.put(CreateFileParams.OPTION_TRANSFORM, FilesTransformationParams.DISABLE);
    create.put(CreateFileParams.OPTION_AD, FilesADParams.ENABLE);
    create.put(CreateFileParams.RESOLUTION, FilesResolutions.RES_LOW);

    try {
      mPublitio.files().uploadFile(fileUri, create, new PublitioCallback<JsonObject>() {
        @Override
        public void success(JsonObject res) {
          Gson gson = new Gson();
          String json = gson.toJson(res);
          Map hashmap = gson.fromJson(json, Map.class);
          result.success(hashmap);

        }

        @Override
        public void failure(String message) {
          result.error("upload_error", message, null);
        }
      });
    } catch (PublitioExceptions publitioExceptions) {
      result.error("upload_error", publitioExceptions.toString(), null);
    }

  }
}
