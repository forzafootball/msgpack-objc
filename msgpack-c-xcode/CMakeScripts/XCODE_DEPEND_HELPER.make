# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.msgpackc.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.dylib:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.dylib


PostBuild.msgpackc-static.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.a:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.a


PostBuild.lib_buffer_unpack.Debug:
PostBuild.msgpackc.Debug: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/lib_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/lib_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/lib_buffer_unpack


PostBuild.simple_c.Debug:
PostBuild.msgpackc.Debug: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/simple_c
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/simple_c:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/simple_c


PostBuild.speed_test_uint32_array.Debug:
PostBuild.msgpackc.Debug: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint32_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint32_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint32_array


PostBuild.speed_test_uint64_array.Debug:
PostBuild.msgpackc.Debug: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint64_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint64_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/speed_test_uint64_array


PostBuild.user_buffer_unpack.Debug:
PostBuild.msgpackc.Debug: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/user_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/user_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Debug/user_buffer_unpack


PostBuild.class_intrusive.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_intrusive


PostBuild.class_intrusive_map.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_intrusive_map:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_intrusive_map


PostBuild.class_non_intrusive.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_non_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/class_non_intrusive


PostBuild.custom.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/custom:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/custom


PostBuild.enum.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/enum:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/enum


PostBuild.map_based_versionup.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/map_based_versionup:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/map_based_versionup


PostBuild.protocol_new.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/protocol_new:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/protocol_new


PostBuild.reuse_zone.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/reuse_zone:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/reuse_zone


PostBuild.simple.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/simple:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/simple


PostBuild.stream.Debug:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/stream:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Debug/stream


PostBuild.msgpackc.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.dylib:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.dylib


PostBuild.msgpackc-static.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.a:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.a


PostBuild.lib_buffer_unpack.Release:
PostBuild.msgpackc.Release: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/lib_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/lib_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/lib_buffer_unpack


PostBuild.simple_c.Release:
PostBuild.msgpackc.Release: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/simple_c
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/simple_c:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/simple_c


PostBuild.speed_test_uint32_array.Release:
PostBuild.msgpackc.Release: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint32_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint32_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint32_array


PostBuild.speed_test_uint64_array.Release:
PostBuild.msgpackc.Release: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint64_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint64_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/speed_test_uint64_array


PostBuild.user_buffer_unpack.Release:
PostBuild.msgpackc.Release: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/user_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/user_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/Release/user_buffer_unpack


PostBuild.class_intrusive.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_intrusive


PostBuild.class_intrusive_map.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_intrusive_map:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_intrusive_map


PostBuild.class_non_intrusive.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_non_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/class_non_intrusive


PostBuild.custom.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/custom:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/custom


PostBuild.enum.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/enum:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/enum


PostBuild.map_based_versionup.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/map_based_versionup:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/map_based_versionup


PostBuild.protocol_new.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/protocol_new:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/protocol_new


PostBuild.reuse_zone.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/reuse_zone:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/reuse_zone


PostBuild.simple.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/simple:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/simple


PostBuild.stream.Release:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/stream:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/Release/stream


PostBuild.msgpackc.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.dylib:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.dylib


PostBuild.msgpackc-static.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.a:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.a


PostBuild.lib_buffer_unpack.MinSizeRel:
PostBuild.msgpackc.MinSizeRel: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/lib_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/lib_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/lib_buffer_unpack


PostBuild.simple_c.MinSizeRel:
PostBuild.msgpackc.MinSizeRel: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/simple_c
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/simple_c:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/simple_c


PostBuild.speed_test_uint32_array.MinSizeRel:
PostBuild.msgpackc.MinSizeRel: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint32_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint32_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint32_array


PostBuild.speed_test_uint64_array.MinSizeRel:
PostBuild.msgpackc.MinSizeRel: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint64_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint64_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/speed_test_uint64_array


PostBuild.user_buffer_unpack.MinSizeRel:
PostBuild.msgpackc.MinSizeRel: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/user_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/user_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/MinSizeRel/user_buffer_unpack


PostBuild.class_intrusive.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_intrusive


PostBuild.class_intrusive_map.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_intrusive_map:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_intrusive_map


PostBuild.class_non_intrusive.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_non_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/class_non_intrusive


PostBuild.custom.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/custom:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/custom


PostBuild.enum.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/enum:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/enum


PostBuild.map_based_versionup.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/map_based_versionup:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/map_based_versionup


PostBuild.protocol_new.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/protocol_new:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/protocol_new


PostBuild.reuse_zone.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/reuse_zone:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/reuse_zone


PostBuild.simple.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/simple:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/simple


PostBuild.stream.MinSizeRel:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/stream:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/MinSizeRel/stream


PostBuild.msgpackc.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.dylib:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.dylib


PostBuild.msgpackc-static.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.a:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.a


PostBuild.lib_buffer_unpack.RelWithDebInfo:
PostBuild.msgpackc.RelWithDebInfo: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/lib_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/lib_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/lib_buffer_unpack


PostBuild.simple_c.RelWithDebInfo:
PostBuild.msgpackc.RelWithDebInfo: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/simple_c
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/simple_c:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/simple_c


PostBuild.speed_test_uint32_array.RelWithDebInfo:
PostBuild.msgpackc.RelWithDebInfo: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint32_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint32_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint32_array


PostBuild.speed_test_uint64_array.RelWithDebInfo:
PostBuild.msgpackc.RelWithDebInfo: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint64_array
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint64_array:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/speed_test_uint64_array


PostBuild.user_buffer_unpack.RelWithDebInfo:
PostBuild.msgpackc.RelWithDebInfo: /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/user_buffer_unpack
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/user_buffer_unpack:\
	/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/c/RelWithDebInfo/user_buffer_unpack


PostBuild.class_intrusive.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_intrusive


PostBuild.class_intrusive_map.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_intrusive_map:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_intrusive_map


PostBuild.class_non_intrusive.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_non_intrusive:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/class_non_intrusive


PostBuild.custom.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/custom:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/custom


PostBuild.enum.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/enum:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/enum


PostBuild.map_based_versionup.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/map_based_versionup:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/map_based_versionup


PostBuild.protocol_new.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/protocol_new:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/protocol_new


PostBuild.reuse_zone.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/reuse_zone:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/reuse_zone


PostBuild.simple.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/simple:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/simple


PostBuild.stream.RelWithDebInfo:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/stream:
	/bin/rm -f /Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/example/cpp03/RelWithDebInfo/stream




# For each target create a dummy ruleso the target does not have to exist
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Debug/libmsgpackc.2.0.0.dylib:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/MinSizeRel/libmsgpackc.2.0.0.dylib:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/RelWithDebInfo/libmsgpackc.2.0.0.dylib:
/Users/Joel/Downloads/MessagePackTest/msgpack-objc/msgpack-c-xcode/Release/libmsgpackc.2.0.0.dylib:
