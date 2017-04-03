--- tensorflow/bazel-tensorflow/external/protobuf/protobuf.bzl  2017-04-03 17:09:23.837408446 +0200
+++ protobuf-patch.bzl  2017-04-03 16:36:31.082577720 +0200
@@ -108,6 +108,7 @@
         arguments=args + import_flags + [s.path for s in srcs],
         executable=ctx.executable.protoc,
         mnemonic="ProtoCompile",
+        use_default_shell_env=True,
     )

   return struct(
