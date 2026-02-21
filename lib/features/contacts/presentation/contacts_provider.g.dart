// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contactsNotifierHash() => r'f5ca2bddaf3853c79fb2a55e964170a343bab003';

/// See also [ContactsNotifier].
@ProviderFor(ContactsNotifier)
final contactsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ContactsNotifier, List<Contact>>.internal(
      ContactsNotifier.new,
      name: r'contactsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contactsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ContactsNotifier = AutoDisposeAsyncNotifier<List<Contact>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
