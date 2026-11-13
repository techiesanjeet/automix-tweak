AutoMix

AUTOMIX COMPREHENSIVE DISCOVERY V5
Bundle: com.s.z
Version: 9.1.90
Date: 2026-11-12 23:56:43 +0000
READ-ONLY CLASS/METADATA SCAN. Does not instantiate Spotify objects, invoke Spotify methods, inspect audio buffers, decode media, or access track contents.
Runtime classes: 121287 | matched classes: 1559 | detail cap: 240 classes
Swift-only method bodies may not be exposed through Objective-C runtime metadata.

===== CLASS _AFAudioPlaybackRequestMutation =====
IMAGE /System/Library/PrivateFrameworks/AssistantServices.framework/AssistantServices
SUPER NSObject
IVARS 11
  _base | type=@"AFAudioPlaybackRequest" | offset=8
  _itemURL | type=@"NSURL" | offset=16
  _itemData | type=@"NSData" | offset=24
  _numberOfLoops | type=q | offset=32
  _volume | type=f | offset=40
  _fadeInDuration | type=d | offset=48
  _fadeOutDuration | type=d | offset=56
  _userInfo | type=@"NSDictionary" | offset=64
  _hapticLibraryKey | type=@"NSString" | offset=72
  _UUID | type=@"NSString" | offset=80
  _mutationFlags | type={_mutationFlags="isDirty"b1"hasItemURL"b1"hasItemData"b1"hasNumberOfLoops"b1"hasVolume"b1"hasFadeInDuration"b1"hasFadeOutDuration"b1"hasUserInfo"b1"hasHapticLibraryKey"b1"hasUUID"b1} | offset=88
PROPERTIES 4
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  AFAudioPlaybackRequestMutating
DIRECT_INSTANCE_METHODS 21
  setUserInfo: | types=v24@0:8@16
  initWithBase: | types=@24@0:8@16
  setItemURL: | types=v24@0:8@16
  setVolume: | types=v20@0:8f16
  isDirty | types=B16@0:8
  getUUID | types=@16@0:8
  .cxx_destruct | types=v16@0:8
  setUUID: | types=v24@0:8@16
  setFadeInDuration: | types=v24@0:8d16
  setFadeOutDuration: | types=v24@0:8d16
  setNumberOfLoops: | types=v24@0:8q16
  getFadeInDuration | types=d16@0:8
  getFadeOutDuration | types=d16@0:8
  getHapticLibraryKey | types=@16@0:8
  getItemData | types=@16@0:8
  getItemURL | types=@16@0:8
  getNumberOfLoops | types=q16@0:8
  getUserInfo | types=@16@0:8
  getVolume | types=f16@0:8
  setHapticLibraryKey: | types=v24@0:8@16
  setItemData: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _AFMediaPlaybackStateSnapshotMutation =====
IMAGE /System/Library/PrivateFrameworks/AssistantServices.framework/AssistantServices
SUPER NSObject
IVARS 7
  _base | type=@"AFMediaPlaybackStateSnapshot" | offset=8
  _playbackState | type=q | offset=16
  _nowPlayingTimestamp | type=@"NSDate" | offset=24
  _mediaType | type=@"NSString" | offset=32
  _groupIdentifier | type=@"NSString" | offset=40
  _isProxyGroupPlayer | type=B | offset=48
  _mutationFlags | type={_mutationFlags="isDirty"b1"hasPlaybackState"b1"hasNowPlayingTimestamp"b1"hasMediaType"b1"hasGroupIdentifier"b1"hasIsProxyGroupPlayer"b1} | offset=52
PROPERTIES 4
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  AFMediaPlaybackStateSnapshotMutating
DIRECT_INSTANCE_METHODS 13
  setPlaybackState: | types=v24@0:8q16
  setGroupIdentifier: | types=v24@0:8@16
  initWithBase: | types=@24@0:8@16
  setMediaType: | types=v24@0:8@16
  isDirty | types=B16@0:8
  .cxx_destruct | types=v16@0:8
  setIsProxyGroupPlayer: | types=v20@0:8B16
  getGroupIdentifier | types=@16@0:8
  getIsProxyGroupPlayer | types=B16@0:8
  getMediaType | types=@16@0:8
  getNowPlayingTimestamp | types=@16@0:8
  getPlaybackState | types=q16@0:8
  setNowPlayingTimestamp: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _GEODirectionsServiceRequestBuilder_DrivingToWalkingTransition =====
IMAGE /System/Library/PrivateFrameworks/GeoServices.framework/GeoServices
SUPER GEODirectionsServiceRequestBuilder
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 2
  directionsRequestFeedbackPurpose | types=i16@0:8
  waypointsForRoute | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _GEODirectionsServiceRequestBuilder_OfflineToOnlineTransition =====
IMAGE /System/Library/PrivateFrameworks/GeoServices.framework/GeoServices
SUPER GEODirectionsServiceRequestBuilder
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  directionsRequestFeedbackPurpose | types=i16@0:8
  originalWaypointRoutePurpose | types=i16@0:8
  waypointsForRoute | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _GEODirectionsServiceRequestBuilder_OnlineToOfflineTransition =====
IMAGE /System/Library/PrivateFrameworks/GeoServices.framework/GeoServices
SUPER GEODirectionsServiceRequestBuilder
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  directionsRequestFeedbackPurpose | types=i16@0:8
  originalWaypointRoutePurpose | types=i16@0:8
  waypointsForRoute | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _GEODirectionsServiceRequestBuilder_PrepareToParkTransition =====
IMAGE /System/Library/PrivateFrameworks/GeoServices.framework/GeoServices
SUPER GEODirectionsServiceRequestBuilder
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 2
  directionsRequestFeedbackPurpose | types=i16@0:8
  waypointsForRoute | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLCurrentItemTransitionAction =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 2
  _previousItemId | type=@"NSString" | offset=8
  _transitionItemId | type=@"NSString" | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLCurrentItemTransitionCommand =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 2
  _previousItemId | type=@"NSString" | offset=8
  _transitionItemId | type=@"NSString" | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackControlSettings =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 8
  _autoPlay | type=@"_ICLLAutoPlaySource" | offset=8
  _availability | type=@"_ICLLAvailability" | offset=16
  _noGeneration | type=@"_ICLLNoGenerationSource" | offset=24
  _radio | type=@"_ICLLRadioSource" | offset=32
  _repeatMode | type=i | offset=40
  _shuffleMode | type=i | offset=44
  _trackGenerationSource | type=i | offset=48
  _has | type={?="repeatMode"b1"shuffleMode"b1"trackGenerationSource"b1} | offset=52
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackControlSettingsCommand =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 1
  _settings | type=@"_ICLLPlaybackControlSettings" | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackControlSettingsQuery =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 1
  _settings | type=@"_ICLLPlaybackControlSettings" | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackItem =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 8
  _contributingParticipantId | type=q | offset=8
  _container | type=@"_ICLLPlaybackItemContainer" | offset=16
  _itemId | type=@"NSString" | offset=24
  _mediaId | type=@"NSString" | offset=32
  _mediaInfo | type=@"_ICLLMediaInfo" | offset=40
  _sectionType | type=i | offset=48
  _isExplicit | type=B | offset=52
  _has | type={?="contributingParticipantId"b1"sectionType"b1"isExplicit"b1} | offset=56
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackItemContainer =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 6
  _containerId | type=@"NSString" | offset=8
  _featureName | type=@"NSString" | offset=16
  _mediaId | type=@"NSString" | offset=24
  _stationHash | type=@"NSString" | offset=32
  _type | type=i | offset=40
  _has | type={?="type"b1} | offset=44
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackSyncAction =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 4
  _participantState | type=@"NSString" | offset=8
  _payload | type=i | offset=16
  _transportControlState | type=@"NSString" | offset=24
  _has | type={?="payload"b1} | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackSyncCommand =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 4
  _participantState | type=@"NSString" | offset=8
  _payload | type=i | offset=16
  _transportControlState | type=@"NSString" | offset=24
  _has | type={?="payload"b1} | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _ICLLPlaybackSyncStateQuery =====
IMAGE /System/Library/PrivateFrameworks/iTunesCloud.framework/iTunesCloud
SUPER PBCodable
IVARS 6
  _currentItemId | type=@"NSString" | offset=8
  _initialAVSyncStartItemId | type=@"NSString" | offset=16
  _participantStates | type=@"NSMutableArray" | offset=24
  _transportControlStates | type=@"NSMutableArray" | offset=32
  _initialAVSyncInitiator | type=B | offset=40
  _has | type={?="initialAVSyncInitiator"b1} | offset=44
PROPERTIES 0
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _INPBStartPhotoPlaybackIntent =====
IMAGE /System/Library/Frameworks/Intents.framework/Intents
SUPER PBCodable
IVARS 9
  _excludedAttributes | type={?="list"^i"count"Q"size"Q} | offset=8
  _includedAttributes | type={?="list"^i"count"Q"size"Q} | offset=32
  _has | type={?=} | offset=56
  _albumName | type=@"_INPBString" | offset=56
  _dateCreated | type=@"_INPBDateTimeRange" | offset=64
  _intentMetadata | type=@"_INPBIntentMetadata" | offset=72
  _locationCreated | type=@"_INPBLocation" | offset=80
  _peopleInPhoto | type=@"_INPBContactList" | offset=88
  _searchTerm | type=@"_INPBStringList" | offset=96
PROPERTIES 20
  albumName | T@"_INPBString",&,N,V_albumName
  hasAlbumName | TB,R,N
  dateCreated | T@"_INPBDateTimeRange",&,N,V_dateCreated
  hasDateCreated | TB,R,N
  excludedAttributes | T^i,R,N
  excludedAttributesCount | TQ,R,N
  includedAttributes | T^i,R,N
  includedAttributesCount | TQ,R,N
  intentMetadata | T@"_INPBIntentMetadata",&,N,V_intentMetadata
  hasIntentMetadata | TB,R,N
  locationCreated | T@"_INPBLocation",&,N,V_locationCreated
  hasLocationCreated | TB,R,N
  peopleInPhoto | T@"_INPBContactList",&,N,V_peopleInPhoto
  hasPeopleInPhoto | TB,R,N
  searchTerm | T@"_INPBStringList",&,N,V_searchTerm
  hasSearchTerm | TB,R,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 3
  _INPBStartPhotoPlaybackIntent
  NSSecureCoding
  NSCopying
DIRECT_INSTANCE_METHODS 44
  albumName | types=@16@0:8
  setIntentMetadata: | types=v24@0:8@16
  setSearchTerm: | types=v24@0:8@16
  searchTerm | types=@16@0:8
  hasIntentMetadata | types=B16@0:8
  dateCreated | types=@16@0:8
  intentMetadata | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  setAlbumName: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasAlbumName | types=B16@0:8
  dealloc | types=v16@0:8
  isEqual: | types=B24@0:8@16
  setPeopleInPhoto: | types=v24@0:8@16
  peopleInPhoto | types=@16@0:8
  encodeWithCoder: | types=v24@0:8@16
  hasSearchTerm | types=B16@0:8
  initWithCoder: | types=@24@0:8@16
  readFrom: | types=B24@0:8@16
  setDateCreated: | types=v24@0:8@16
  StringAsExcludedAttributes: | types=i24@0:8@16
  StringAsIncludedAttributes: | types=i24@0:8@16
  locationCreated | types=@16@0:8
  addExcludedAttribute: | types=v20@0:8i16
  addIncludedAttribute: | types=v20@0:8i16
  clearExcludedAttributes | types=v16@0:8
  clearIncludedAttributes | types=v16@0:8
  excludedAttributeAtIndex: | types=i24@0:8Q16
  excludedAttributes | types=^i16@0:8
  excludedAttributesAsString: | types=@20@0:8i16
  excludedAttributesCount | types=Q16@0:8
  hasDateCreated | types=B16@0:8
  hasLocationCreated | types=B16@0:8
  hasPeopleInPhoto | types=B16@0:8
  includedAttributeAtIndex: | types=i24@0:8Q16
  includedAttributes | types=^i16@0:8
  includedAttributesAsString: | types=@20@0:8i16
  includedAttributesCount | types=Q16@0:8
  setExcludedAttributes:count: | types=v32@0:8^i16Q24
  setIncludedAttributes:count: | types=v32@0:8^i16Q24
  setLocationCreated: | types=v24@0:8@16
DIRECT_CLASS_METHODS 1
  supportsSecureCoding | types=B16@0:8

===== CLASS _INPBStartPhotoPlaybackIntentResponse =====
IMAGE /System/Library/Frameworks/Intents.framework/Intents
SUPER PBCodable
IVARS 4
  _has | type={?="searchResultsCount"b1} | offset=8
  _searchResultsCount | type=i | offset=12
  _albumName | type=@"NSString" | offset=16
  _locationCreated | type=@"_INPBLocation" | offset=24
PROPERTIES 10
  albumName | T@"NSString",C,N,V_albumName
  hasAlbumName | TB,R,N
  locationCreated | T@"_INPBLocation",&,N,V_locationCreated
  hasLocationCreated | TB,R,N
  searchResultsCount | Ti,N,V_searchResultsCount
  hasSearchResultsCount | TB,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 3
  _INPBStartPhotoPlaybackIntentResponse
  NSSecureCoding
  NSCopying
DIRECT_INSTANCE_METHODS 19
  albumName | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  setAlbumName: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasAlbumName | types=B16@0:8
  isEqual: | types=B24@0:8@16
  encodeWithCoder: | types=v24@0:8@16
  initWithCoder: | types=@24@0:8@16
  readFrom: | types=B24@0:8@16
  locationCreated | types=@16@0:8
  hasLocationCreated | types=B16@0:8
  hasSearchResultsCount | types=B16@0:8
  searchResultsCount | types=i16@0:8
  setHasSearchResultsCount: | types=v20@0:8B16
  setLocationCreated: | types=v24@0:8@16
  setSearchResultsCount: | types=v20@0:8i16
DIRECT_CLASS_METHODS 1
  supportsSecureCoding | types=B16@0:8

===== CLASS _MRPlaybackQueueCapabilitiesProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 4
  _requestByIdentifiers | type=B | offset=8
  _requestByRange | type=B | offset=9
  _requestByRequest | type=B | offset=10
  _has | type={?="requestByIdentifiers"b1"requestByRange"b1"requestByRequest"b1} | offset=12
PROPERTIES 6
  hasRequestByRange | TB,N
  requestByRange | TB,N,V_requestByRange
  hasRequestByIdentifiers | TB,N
  requestByIdentifiers | TB,N,V_requestByIdentifiers
  hasRequestByRequest | TB,N
  requestByRequest | TB,N,V_requestByRequest
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 21
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  hasRequestByIdentifiers | types=B16@0:8
  hasRequestByRange | types=B16@0:8
  hasRequestByRequest | types=B16@0:8
  requestByIdentifiers | types=B16@0:8
  requestByRange | types=B16@0:8
  requestByRequest | types=B16@0:8
  setHasRequestByIdentifiers: | types=v20@0:8B16
  setHasRequestByRange: | types=v20@0:8B16
  setHasRequestByRequest: | types=v20@0:8B16
  setRequestByIdentifiers: | types=v20@0:8B16
  setRequestByRange: | types=v20@0:8B16
  setRequestByRequest: | types=v20@0:8B16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackQueueContextProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 1
  _revision | type=@"NSString" | offset=8
PROPERTIES 2
  hasRevision | TB,R,N
  revision | T@"NSString",&,N,V_revision
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 13
  revision | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  hasRevision | types=B16@0:8
  setRevision: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackQueueParticipantProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 2
  _identifier | type=@"NSString" | offset=8
  _identity | type=@"_MRUserIdentityProtobuf" | offset=16
PROPERTIES 4
  hasIdentifier | TB,R,N
  identifier | T@"NSString",&,N,V_identifier
  hasIdentity | TB,R,N
  identity | T@"_MRUserIdentityProtobuf",&,N,V_identity
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 16
  setIdentity: | types=v24@0:8@16
  hasIdentifier | types=B16@0:8
  identifier | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  identity | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasIdentity | types=B16@0:8
  isEqual: | types=B24@0:8@16
  setIdentifier: | types=v24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackQueueProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 12
  _auxiliaryNowPlayingInfo | type=@"_MRDictionaryProtobuf" | offset=8
  _contentItems | type=@"NSMutableArray" | offset=16
  _context | type=@"_MRPlaybackQueueContextProtobuf" | offset=24
  _homeUserIdentifiers | type=@"NSMutableArray" | offset=32
  _location | type=i | offset=40
  _participants | type=@"NSMutableArray" | offset=48
  _properties | type=@"_MRDictionaryProtobuf" | offset=56
  _queueIdentifier | type=@"NSString" | offset=64
  _requestID | type=@"NSString" | offset=72
  _resolvedPlayerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=80
  _sendingPlaybackQueueTransaction | type=B | offset=88
  _has | type={?="location"b1"sendingPlaybackQueueTransaction"b1} | offset=92
PROPERTIES 19
  hasLocation | TB,N
  location | Ti,N,V_location
  contentItems | T@"NSMutableArray",&,N,V_contentItems
  hasContext | TB,R,N
  context | T@"_MRPlaybackQueueContextProtobuf",&,N,V_context
  hasRequestID | TB,R,N
  requestID | T@"NSString",&,N,V_requestID
  hasResolvedPlayerPath | TB,R,N
  resolvedPlayerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_resolvedPlayerPath
  hasSendingPlaybackQueueTransaction | TB,N
  sendingPlaybackQueueTransaction | TB,N,V_sendingPlaybackQueueTransaction
  hasQueueIdentifier | TB,R,N
  queueIdentifier | T@"NSString",&,N,V_queueIdentifier
  participants | T@"NSMutableArray",&,N,V_participants
  homeUserIdentifiers | T@"NSMutableArray",&,N,V_homeUserIdentifiers
  hasProperties | TB,R,N
  properties | T@"_MRDictionaryProtobuf",&,N,V_properties
  hasAuxiliaryNowPlayingInfo | TB,R,N
  auxiliaryNowPlayingInfo | T@"_MRDictionaryProtobuf",&,N,V_auxiliaryNowPlayingInfo
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 54
  setRequestID: | types=v24@0:8@16
  requestID | types=@16@0:8
  setContext: | types=v24@0:8@16
  hasRequestID | types=B16@0:8
  contentItemsCount | types=Q16@0:8
  setParticipants: | types=v24@0:8@16
  homeUserIdentifiers | types=@16@0:8
  clearParticipants | types=v16@0:8
  participants | types=@16@0:8
  hasLocation | types=B16@0:8
  setHomeUserIdentifiers: | types=v24@0:8@16
  clearHomeUserIdentifiers | types=v16@0:8
  setQueueIdentifier: | types=v24@0:8@16
  participantsCount | types=Q16@0:8
  hasContext | types=B16@0:8
  queueIdentifier | types=@16@0:8
  setHasLocation: | types=v20@0:8B16
  setContentItems: | types=v24@0:8@16
  setProperties: | types=v24@0:8@16
  hasQueueIdentifier | types=B16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  hasResolvedPlayerPath | types=B16@0:8
  dictionaryRepresentation | types=@16@0:8
  clearContentItems | types=v16@0:8
  hasProperties | types=B16@0:8
  setResolvedPlayerPath: | types=v24@0:8@16
  mergeFrom: | types=v24@0:8@16
  resolvedPlayerPath | types=@16@0:8
  homeUserIdentifiersCount | types=Q16@0:8
  hasAuxiliaryNowPlayingInfo | types=B16@0:8
  location | types=i16@0:8
  addParticipants: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasSendingPlaybackQueueTransaction | types=B16@0:8
  isEqual: | types=B24@0:8@16
  contentItemAtIndex: | types=@24@0:8Q16
  setSendingPlaybackQueueTransaction: | types=v20@0:8B16
  properties | types=@16@0:8
  sendingPlaybackQueueTransaction | types=B16@0:8
  auxiliaryNowPlayingInfo | types=@16@0:8
  homeUserIdentifiersAtIndex: | types=@24@0:8Q16
  addHomeUserIdentifiers: | types=v24@0:8@16
  context | types=@16@0:8
  participantsAtIndex: | types=@24@0:8Q16
  setHasSendingPlaybackQueueTransaction: | types=v20@0:8B16
  contentItems | types=@16@0:8
  addContentItem: | types=v24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  setAuxiliaryNowPlayingInfo: | types=v24@0:8@16
  readFrom: | types=B24@0:8@16
  setLocation: | types=v20@0:8i16
DIRECT_CLASS_METHODS 3
  participantsType | types=#16@0:8
  contentItemType | types=#16@0:8
  homeUserIdentifiersType | types=#16@0:8

===== CLASS _MRPlaybackQueueRequestProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 25
  _artworkHeight | type=d | offset=8
  _artworkWidth | type=d | offset=16
  _cachingPolicy | type=i | offset=24
  _contentItemIdentifiers | type=@"NSMutableArray" | offset=32
  _context | type=@"_MRPlaybackQueueContextProtobuf" | offset=40
  _label | type=@"NSString" | offset=48
  _length | type=i | offset=56
  _location | type=i | offset=60
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=64
  _requestID | type=@"NSString" | offset=72
  _requestedAnimatedArtworkAssetURLFormats | type=@"NSMutableArray" | offset=80
  _requestedAnimatedArtworkPreviewFrameFormats | type=@"NSMutableArray" | offset=88
  _requestedArtworkFormats | type=@"NSMutableArray" | offset=96
  _requestedRemoteArtworkFormats | type=@"NSMutableArray" | offset=104
  _includeAlignments | type=B | offset=112
  _includeAvailableArtworkFormats | type=B | offset=113
  _includeInfo | type=B | offset=114
  _includeLanguageOptions | type=B | offset=115
  _includeLyrics | type=B | offset=116
  _includeMetadata | type=B | offset=117
  _includeParticipants | type=B | offset=118
  _includeSections | type=B | offset=119
  _isLegacyNowPlayingInfoRequest | type=B | offset=120
  _returnContentItemAssetsInUserCompletion | type=B | offset=121
  _has | type={?="artworkHeight"b1"artworkWidth"b1"cachingPolicy"b1"length"b1"location"b1"includeAlignments"b1"includeAvailableArtworkFormats"b1"includeInfo"b1"includeLanguageOptions"b1"includeLyrics"b1"includeMetadata"b1"includeParticipants"b1"includeSections"b1"isLegacyNowPlayingInfoRequest"b1"returnContentItemAssetsInUserCompletion"b1} | offset=124
PROPERTIES 43
  hasLocation | TB,N
  location | Ti,N,V_location
  hasLength | TB,N
  length | Ti,N,V_length
  hasIncludeMetadata | TB,N
  includeMetadata | TB,N,V_includeMetadata
  hasArtworkWidth | TB,N
  artworkWidth | Td,N,V_artworkWidth
  hasArtworkHeight | TB,N
  artworkHeight | Td,N,V_artworkHeight
  hasIncludeLyrics | TB,N
  includeLyrics | TB,N,V_includeLyrics
  hasIncludeSections | TB,N
  includeSections | TB,N,V_includeSections
  hasIncludeInfo | TB,N
  includeInfo | TB,N,V_includeInfo
  hasIncludeLanguageOptions | TB,N
  includeLanguageOptions | TB,N,V_includeLanguageOptions
  hasContext | TB,R,N
  context | T@"_MRPlaybackQueueContextProtobuf",&,N,V_context
  hasRequestID | TB,R,N
  requestID | T@"NSString",&,N,V_requestID
  contentItemIdentifiers | T@"NSMutableArray",&,N,V_contentItemIdentifiers
  hasReturnContentItemAssetsInUserCompletion | TB,N
  returnContentItemAssetsInUserCompletion | TB,N,V_returnContentItemAssetsInUserCompletion
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
  hasCachingPolicy | TB,N
  cachingPolicy | Ti,N,V_cachingPolicy
  hasLabel | TB,R,N
  label | T@"NSString",&,N,V_label
  hasIsLegacyNowPlayingInfoRequest | TB,N
  isLegacyNowPlayingInfoRequest | TB,N,V_isLegacyNowPlayingInfoRequest
  hasIncludeParticipants | TB,N
  includeParticipants | TB,N,V_includeParticipants
  hasIncludeAvailableArtworkFormats | TB,N
  includeAvailableArtworkFormats | TB,N,V_includeAvailableArtworkFormats
  requestedArtworkFormats | T@"NSMutableArray",&,N,V_requestedArtworkFormats
  requestedRemoteArtworkFormats | T@"NSMutableArray",&,N,V_requestedRemoteArtworkFormats
  hasIncludeAlignments | TB,N
  includeAlignments | TB,N,V_includeAlignments
  requestedAnimatedArtworkPreviewFrameFormats | T@"NSMutableArray",&,N,V_requestedAnimatedArtworkPreviewFrameFormats
  requestedAnimatedArtworkAssetURLFormats | T@"NSMutableArray",&,N,V_requestedAnimatedArtworkAssetURLFormats
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 112
  setRequestID: | types=v24@0:8@16
  contentItemIdentifiers | types=@16@0:8
  requestID | types=@16@0:8
  setContext: | types=v24@0:8@16
  hasRequestID | types=B16@0:8
  includeAvailableArtworkFormats | types=B16@0:8
  hasIncludeMetadata | types=B16@0:8
  clearRequestedAnimatedArtworkPreviewFrameFormats | types=v16@0:8
  hasLocation | types=B16@0:8
  hasContext | types=B16@0:8
  setPlayerPath: | types=v24@0:8@16
  setArtworkHeight: | types=v24@0:8d16
  setRequestedAnimatedArtworkAssetURLFormats: | types=v24@0:8@16
  setHasIsLegacyNowPlayingInfoRequest: | types=v20@0:8B16
  requestedArtworkFormatsAtIndex: | types=@24@0:8Q16
  setHasLength: | types=v20@0:8B16
  hasLabel | types=B16@0:8
  includeLanguageOptions | types=B16@0:8
  setReturnContentItemAssetsInUserCompletion: | types=v20@0:8B16
  requestedAnimatedArtworkAssetURLFormatsAtIndex: | types=@24@0:8Q16
  hasPlayerPath | types=B16@0:8
  addRequestedAnimatedArtworkAssetURLFormats: | types=v24@0:8@16
  isLegacyNowPlayingInfoRequest | types=B16@0:8
  setHasLocation: | types=v20@0:8B16
  playerPath | types=@16@0:8
  setRequestedAnimatedArtworkPreviewFrameFormats: | types=v24@0:8@16
  hash | types=Q16@0:8
  addRequestedAnimatedArtworkPreviewFrameFormats: | types=v24@0:8@16
  requestedRemoteArtworkFormatsCount | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  includeInfo | types=B16@0:8
  dictionaryRepresentation | types=@16@0:8
  contentItemIdentifiersAtIndex: | types=@24@0:8Q16
  mergeFrom: | types=v24@0:8@16
  setHasIncludeParticipants: | types=v20@0:8B16
  addContentItemIdentifiers: | types=v24@0:8@16
  clearRequestedArtworkFormats | types=v16@0:8
  setIncludeMetadata: | types=v20@0:8B16
  clearRequestedRemoteArtworkFormats | types=v16@0:8
  location | types=i16@0:8
  setIsLegacyNowPlayingInfoRequest: | types=v20@0:8B16
  requestedAnimatedArtworkPreviewFrameFormatsCount | types=Q16@0:8
  setHasIncludeInfo: | types=v20@0:8B16
  hasIncludeSections | types=B16@0:8
  returnContentItemAssetsInUserCompletion | types=B16@0:8
  hasIncludeAvailableArtworkFormats | types=B16@0:8
  writeTo: | types=v24@0:8@16
  setHasIncludeMetadata: | types=v20@0:8B16
  includeSections | types=B16@0:8
  setIncludeSections: | types=v20@0:8B16
  setContentItemIdentifiers: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  addRequestedArtworkFormats: | types=v24@0:8@16
  clearContentItemIdentifiers | types=v16@0:8
  hasArtworkHeight | types=B16@0:8
  setHasArtworkWidth: | types=v20@0:8B16
  requestedRemoteArtworkFormatsAtIndex: | types=@24@0:8Q16
  hasIncludeLanguageOptions | types=B16@0:8
  label | types=@16@0:8
  isEqual: | types=B24@0:8@16
  ... 52 methods omitted (limit 60)
DIRECT_CLASS_METHODS 5
  contentItemIdentifiersType | types=#16@0:8
  requestedAnimatedArtworkAssetURLFormatsType | types=#16@0:8
  requestedAnimatedArtworkPreviewFrameFormatsType | types=#16@0:8
  requestedArtworkFormatsType | types=#16@0:8
  requestedRemoteArtworkFormatsType | types=#16@0:8

===== CLASS _MRPlaybackSessionMigrateBeginMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 2
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=8
  _request | type=@"_MRPlaybackSessionRequestProtobuf" | offset=16
PROPERTIES 4
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionRequestProtobuf",&,N,V_request
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 16
  setRequest: | types=v24@0:8@16
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  hasRequest | types=B16@0:8
  playerPath | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionMigrateEndMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 7
  _errorCode | type=q | offset=8
  _error | type=@"_MRErrorProtobuf" | offset=16
  _errorDescription | type=@"NSString" | offset=24
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=32
  _request | type=@"_MRPlaybackSessionRequestProtobuf" | offset=40
  _setPlaybackSessionCommandStatus | type=@"_MRSendCommandResultStatusProtobuf" | offset=48
  _has | type={?="errorCode"b1} | offset=56
PROPERTIES 12
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionRequestProtobuf",&,N,V_request
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
  hasErrorCode | TB,N
  errorCode | Tq,N,V_errorCode
  hasErrorDescription | TB,R,N
  errorDescription | T@"NSString",&,N,V_errorDescription
  hasError | TB,R,N
  error | T@"_MRErrorProtobuf",&,N,V_error
  hasSetPlaybackSessionCommandStatus | TB,R,N
  setPlaybackSessionCommandStatus | T@"_MRSendCommandResultStatusProtobuf",&,N,V_setPlaybackSessionCommandStatus
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 29
  errorDescription | types=@16@0:8
  hasError | types=B16@0:8
  setRequest: | types=v24@0:8@16
  setErrorCode: | types=v24@0:8q16
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  hasRequest | types=B16@0:8
  playerPath | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  hasErrorCode | types=B16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  setError: | types=v24@0:8@16
  setHasErrorCode: | types=v20@0:8B16
  error | types=@16@0:8
  isEqual: | types=B24@0:8@16
  hasErrorDescription | types=B16@0:8
  errorCode | types=q16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  setErrorDescription: | types=v24@0:8@16
  readFrom: | types=B24@0:8@16
  setPlaybackSessionCommandStatus | types=@16@0:8
  hasSetPlaybackSessionCommandStatus | types=B16@0:8
  setSetPlaybackSessionCommandStatus: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionMigratePostMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 5
  _error | type=@"_MRErrorProtobuf" | offset=8
  _metrics | type=@"_MRDictionaryProtobuf" | offset=16
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=24
  _request | type=@"_MRPlaybackSessionMigrateRequestProtobuf" | offset=32
  _setPlaybackSessionCommandID | type=@"NSString" | offset=40
PROPERTIES 10
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionMigrateRequestProtobuf",&,N,V_request
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
  hasSetPlaybackSessionCommandID | TB,R,N
  setPlaybackSessionCommandID | T@"NSString",&,N,V_setPlaybackSessionCommandID
  hasMetrics | TB,R,N
  metrics | T@"_MRDictionaryProtobuf",&,N,V_metrics
  hasError | TB,R,N
  error | T@"_MRErrorProtobuf",&,N,V_error
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 25
  hasError | types=B16@0:8
  metrics | types=@16@0:8
  setRequest: | types=v24@0:8@16
  setMetrics: | types=v24@0:8@16
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  hasRequest | types=B16@0:8
  playerPath | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  setError: | types=v24@0:8@16
  error | types=@16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  hasMetrics | types=B16@0:8
  setSetPlaybackSessionCommandID: | types=v24@0:8@16
  hasSetPlaybackSessionCommandID | types=B16@0:8
  setPlaybackSessionCommandID | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionMigrateRequestEventProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 12
  _endTimestamp | type=d | offset=8
  _errorCode | type=q | offset=16
  _startTimestamp | type=d | offset=24
  _error | type=@"_MRErrorProtobuf" | offset=32
  _errorDescription | type=@"NSString" | offset=40
  _events | type=@"NSMutableArray" | offset=48
  _identifier | type=I | offset=56
  _input | type=@"_MRDictionaryProtobuf" | offset=64
  _name | type=@"NSString" | offset=72
  _output | type=@"_MRDictionaryProtobuf" | offset=80
  _role | type=i | offset=88
  _has | type={?="endTimestamp"b1"errorCode"b1"startTimestamp"b1"identifier"b1"role"b1} | offset=92
PROPERTIES 22
  mr_error | T@"NSError",R,N
  hasName | TB,R,N
  name | T@"NSString",&,N,V_name
  hasStartTimestamp | TB,N
  startTimestamp | Td,N,V_startTimestamp
  hasEndTimestamp | TB,N
  endTimestamp | Td,N,V_endTimestamp
  hasErrorCode | TB,N
  errorCode | Tq,N,V_errorCode
  hasErrorDescription | TB,R,N
  errorDescription | T@"NSString",&,N,V_errorDescription
  hasError | TB,R,N
  error | T@"_MRErrorProtobuf",&,N,V_error
  hasIdentifier | TB,N
  identifier | TI,N,V_identifier
  hasRole | TB,N
  role | Ti,N,V_role
  hasInput | TB,R,N
  input | T@"_MRDictionaryProtobuf",&,N,V_input
  hasOutput | TB,R,N
  output | T@"_MRDictionaryProtobuf",&,N,V_output
  events | T@"NSMutableArray",&,N,V_events
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 56
  errorDescription | types=@16@0:8
  role | types=i16@0:8
  hasError | types=B16@0:8
  input | types=@16@0:8
  setErrorCode: | types=v24@0:8q16
  addEvents: | types=v24@0:8@16
  hasRole | types=B16@0:8
  setOutput: | types=v24@0:8@16
  output | types=@16@0:8
  hasIdentifier | types=B16@0:8
  setRole: | types=v20@0:8i16
  identifier | types=I16@0:8
  setInput: | types=v24@0:8@16
  hash | types=Q16@0:8
  hasName | types=B16@0:8
  setEvents: | types=v24@0:8@16
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  hasErrorCode | types=B16@0:8
  mergeFrom: | types=v24@0:8@16
  events | types=@16@0:8
  setHasRole: | types=v20@0:8B16
  name | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  setError: | types=v24@0:8@16
  setHasErrorCode: | types=v20@0:8B16
  StringAsRole: | types=i24@0:8@16
  calculatedDuration | types=d16@0:8
  error | types=@16@0:8
  isEqual: | types=B24@0:8@16
  endTimestamp | types=d16@0:8
  setIdentifier: | types=v20@0:8I16
  startTimestamp | types=d16@0:8
  hasInput | types=B16@0:8
  setEndTimestamp: | types=v24@0:8d16
  roleAsString: | types=@20@0:8i16
  setHasIdentifier: | types=v20@0:8B16
  hasErrorDescription | types=B16@0:8
  setName: | types=v24@0:8@16
  errorCode | types=q16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  setStartTimestamp: | types=v24@0:8d16
  setErrorDescription: | types=v24@0:8@16
  readFrom: | types=B24@0:8@16
  clearEvents | types=v16@0:8
  eventsAtIndex: | types=@24@0:8Q16
  eventsCount | types=Q16@0:8
  hasEndTimestamp | types=B16@0:8
  hasStartTimestamp | types=B16@0:8
  setHasEndTimestamp: | types=v20@0:8B16
  setHasStartTimestamp: | types=v20@0:8B16
  hasOutput | types=B16@0:8
  mr_error | types=@16@0:8
  reportName | types=@16@0:8
DIRECT_CLASS_METHODS 1
  eventsType | types=#16@0:8

===== CLASS _MRPlaybackSessionMigrateRequestMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 3
  _playbackSession | type=@"_MRPlaybackSessionProtobuf" | offset=8
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=16
  _request | type=@"_MRPlaybackSessionMigrateRequestProtobuf" | offset=24
PROPERTIES 6
  hasPlaybackSession | TB,R,N
  playbackSession | T@"_MRPlaybackSessionProtobuf",&,N,V_playbackSession
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionMigrateRequestProtobuf",&,N,V_request
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 19
  setRequest: | types=v24@0:8@16
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  hasRequest | types=B16@0:8
  playerPath | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  playbackSession | types=@16@0:8
  hasPlaybackSession | types=B16@0:8
  setPlaybackSession: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionMigrateRequestProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 18
  _playbackPosition | type=d | offset=8
  _playbackRate | type=d | offset=16
  _contentItem | type=@"_MRContentItemProtobuf" | offset=24
  _destinationTypes | type=I | offset=32
  _endpointOptions | type=i | offset=36
  _events | type=@"NSMutableArray" | offset=40
  _initiator | type=@"NSString" | offset=48
  _originatorType | type=I | offset=56
  _playbackSessionRequest | type=@"_MRPlaybackSessionRequestProtobuf" | offset=64
  _playbackState | type=i | offset=72
  _playerOptions | type=i | offset=76
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=80
  _recipeType | type=i | offset=88
  _requestID | type=@"NSString" | offset=96
  _resolvedPlayerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=104
  _setPlaybackSessionCommandStatus | type=@"_MRSendCommandResultStatusProtobuf" | offset=112
  _allowFadeTransition | type=B | offset=120
  _has | type={?="playbackPosition"b1"playbackRate"b1"destinationTypes"b1"endpointOptions"b1"originatorType"b1"playbackState"b1"playerOptions"b1"recipeType"b1"allowFadeTransition"b1} | offset=124
PROPERTIES 33
  hasRequestID | TB,R,N
  requestID | T@"NSString",&,N,V_requestID
  hasPlayerOptions | TB,N
  playerOptions | Ti,N,V_playerOptions
  hasEndpointOptions | TB,N
  endpointOptions | Ti,N,V_endpointOptions
  events | T@"NSMutableArray",&,N,V_events
  hasPlaybackPosition | TB,N
  playbackPosition | Td,N,V_playbackPosition
  hasContentItem | TB,R,N
  contentItem | T@"_MRContentItemProtobuf",&,N,V_contentItem
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
  hasPlaybackState | TB,N
  playbackState | Ti,N,V_playbackState
  hasPlaybackRate | TB,N
  playbackRate | Td,N,V_playbackRate
  hasPlaybackSessionRequest | TB,R,N
  playbackSessionRequest | T@"_MRPlaybackSessionRequestProtobuf",&,N,V_playbackSessionRequest
  hasAllowFadeTransition | TB,N
  allowFadeTransition | TB,N,V_allowFadeTransition
  hasOriginatorType | TB,N
  originatorType | TI,N,V_originatorType
  hasDestinationTypes | TB,N
  destinationTypes | TI,N,V_destinationTypes
  hasInitiator | TB,R,N
  initiator | T@"NSString",&,N,V_initiator
  hasResolvedPlayerPath | TB,R,N
  resolvedPlayerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_resolvedPlayerPath
  hasSetPlaybackSessionCommandStatus | TB,R,N
  setPlaybackSessionCommandStatus | T@"_MRSendCommandResultStatusProtobuf",&,N,V_setPlaybackSessionCommandStatus
  hasRecipeType | TB,N
  recipeType | Ti,N,V_recipeType
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 81
  setHasPlaybackRate: | types=v20@0:8B16
  setRequestID: | types=v24@0:8@16
  hasPlaybackRate | types=B16@0:8
  requestID | types=@16@0:8
  hasRequestID | types=B16@0:8
  setInitiator: | types=v24@0:8@16
  addEvents: | types=v24@0:8@16
  setPlaybackState: | types=v20@0:8i16
  playbackState | types=i16@0:8
  initiator | types=@16@0:8
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  playerPath | types=@16@0:8
  playbackRate | types=d16@0:8
  setPlaybackRate: | types=v24@0:8d16
  hash | types=Q16@0:8
  setEvents: | types=v24@0:8@16
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  hasResolvedPlayerPath | types=B16@0:8
  dictionaryRepresentation | types=@16@0:8
  setResolvedPlayerPath: | types=v24@0:8@16
  mergeFrom: | types=v24@0:8@16
  events | types=@16@0:8
  resolvedPlayerPath | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  setContentItem: | types=v24@0:8@16
  isEqual: | types=B24@0:8@16
  hasInitiator | types=B16@0:8
  contentItem | types=@16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  StringAsPlaybackState: | types=i24@0:8@16
  hasPlaybackState | types=B16@0:8
  playbackStateAsString: | types=@20@0:8i16
  setHasPlaybackState: | types=v20@0:8B16
  clearEvents | types=v16@0:8
  eventsAtIndex: | types=@24@0:8Q16
  eventsCount | types=Q16@0:8
  playbackPosition | types=d16@0:8
  setPlaybackPosition: | types=v24@0:8d16
  StringAsEndpointOptions: | types=i24@0:8@16
  StringAsPlayerOptions: | types=i24@0:8@16
  StringAsRecipeType: | types=i24@0:8@16
  endpointOptions | types=i16@0:8
  setPlaybackSessionCommandStatus | types=@16@0:8
  allowFadeTransition | types=B16@0:8
  destinationTypes | types=I16@0:8
  endpointOptionsAsString: | types=@20@0:8i16
  hasAllowFadeTransition | types=B16@0:8
  hasContentItem | types=B16@0:8
  hasDestinationTypes | types=B16@0:8
  hasEndpointOptions | types=B16@0:8
  hasOriginatorType | types=B16@0:8
  hasPlaybackPosition | types=B16@0:8
  hasPlaybackSessionRequest | types=B16@0:8
  hasPlayerOptions | types=B16@0:8
  hasRecipeType | types=B16@0:8
  hasSetPlaybackSessionCommandStatus | types=B16@0:8
  ... 21 methods omitted (limit 60)
DIRECT_CLASS_METHODS 1
  eventsType | types=#16@0:8

===== CLASS _MRPlaybackSessionMigrateResponseMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 1
  _request | type=@"_MRPlaybackSessionMigrateRequestProtobuf" | offset=8
PROPERTIES 2
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionMigrateRequestProtobuf",&,N,V_request
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 13
  setRequest: | types=v24@0:8@16
  hasRequest | types=B16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 5
  _identifier | type=@"NSString" | offset=8
  _metadata | type=@"NSData" | offset=16
  _playbackSessionData | type=@"NSData" | offset=24
  _revision | type=@"NSString" | offset=32
  _type | type=@"NSString" | offset=40
PROPERTIES 10
  hasPlaybackSessionData | TB,R,N
  playbackSessionData | T@"NSData",&,N,V_playbackSessionData
  hasIdentifier | TB,R,N
  identifier | T@"NSString",&,N,V_identifier
  hasType | TB,R,N
  type | T@"NSString",&,N,V_type
  hasRevision | TB,R,N
  revision | T@"NSString",&,N,V_revision
  hasMetadata | TB,R,N
  metadata | T@"NSData",&,N,V_metadata
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 25
  hasMetadata | types=B16@0:8
  revision | types=@16@0:8
  hasIdentifier | types=B16@0:8
  identifier | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasType | types=B16@0:8
  setMetadata: | types=v24@0:8@16
  isEqual: | types=B24@0:8@16
  setIdentifier: | types=v24@0:8@16
  setType: | types=v24@0:8@16
  type | types=@16@0:8
  metadata | types=@16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  hasRevision | types=B16@0:8
  setRevision: | types=v24@0:8@16
  playbackSessionData | types=@16@0:8
  hasPlaybackSessionData | types=B16@0:8
  setPlaybackSessionData: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionRequestMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 2
  _playerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=8
  _request | type=@"_MRPlaybackSessionRequestProtobuf" | offset=16
PROPERTIES 4
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionRequestProtobuf",&,N,V_request
  hasPlayerPath | TB,R,N
  playerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_playerPath
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 16
  setRequest: | types=v24@0:8@16
  setPlayerPath: | types=v24@0:8@16
  hasPlayerPath | types=B16@0:8
  hasRequest | types=B16@0:8
  playerPath | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionRequestProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 7
  _destinationCommandInfo | type=@"_MRDictionaryProtobuf" | offset=8
  _destinationPlayerPath | type=@"_MRNowPlayingPlayerPathProtobuf" | offset=16
  _identifier | type=@"NSString" | offset=24
  _requestID | type=@"NSString" | offset=32
  _type | type=@"NSString" | offset=40
  _isPreflight | type=B | offset=48
  _has | type={?="isPreflight"b1} | offset=52
PROPERTIES 12
  hasRequestID | TB,R,N
  requestID | T@"NSString",&,N,V_requestID
  hasIdentifier | TB,R,N
  identifier | T@"NSString",&,N,V_identifier
  hasType | TB,R,N
  type | T@"NSString",&,N,V_type
  hasDestinationPlayerPath | TB,R,N
  destinationPlayerPath | T@"_MRNowPlayingPlayerPathProtobuf",&,N,V_destinationPlayerPath
  hasDestinationCommandInfo | TB,R,N
  destinationCommandInfo | T@"_MRDictionaryProtobuf",&,N,V_destinationCommandInfo
  hasIsPreflight | TB,N
  isPreflight | TB,N,V_isPreflight
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 29
  setRequestID: | types=v24@0:8@16
  requestID | types=@16@0:8
  hasRequestID | types=B16@0:8
  hasIdentifier | types=B16@0:8
  identifier | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  hasType | types=B16@0:8
  isEqual: | types=B24@0:8@16
  setIdentifier: | types=v24@0:8@16
  setType: | types=v24@0:8@16
  type | types=@16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  destinationCommandInfo | types=@16@0:8
  destinationPlayerPath | types=@16@0:8
  isPreflight | types=B16@0:8
  setIsPreflight: | types=v20@0:8B16
  hasDestinationCommandInfo | types=B16@0:8
  hasDestinationPlayerPath | types=B16@0:8
  hasIsPreflight | types=B16@0:8
  setDestinationCommandInfo: | types=v24@0:8@16
  setDestinationPlayerPath: | types=v24@0:8@16
  setHasIsPreflight: | types=v20@0:8B16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPlaybackSessionResponseMessageProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 2
  _playbackSession | type=@"_MRPlaybackSessionProtobuf" | offset=8
  _request | type=@"_MRPlaybackSessionMigrateRequestProtobuf" | offset=16
PROPERTIES 4
  hasPlaybackSession | TB,R,N
  playbackSession | T@"_MRPlaybackSessionProtobuf",&,N,V_playbackSession
  hasRequest | TB,R,N
  request | T@"_MRPlaybackSessionMigrateRequestProtobuf",&,N,V_request
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 16
  setRequest: | types=v24@0:8@16
  hasRequest | types=B16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  request | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  playbackSession | types=@16@0:8
  hasPlaybackSession | types=B16@0:8
  setPlaybackSession: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRPreloadedPlaybackSessionInfo =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 4
  _playbackSessionIdentifier | type=@"NSString" | offset=8
  _playbackSessionPriority | type=i | offset=16
  _playbackSessionRevision | type=@"NSString" | offset=24
  _has | type={?="playbackSessionPriority"b1} | offset=32
PROPERTIES 6
  hasPlaybackSessionIdentifier | TB,R,N
  playbackSessionIdentifier | T@"NSString",&,N,V_playbackSessionIdentifier
  hasPlaybackSessionRevision | TB,R,N
  playbackSessionRevision | T@"NSString",&,N,V_playbackSessionRevision
  hasPlaybackSessionPriority | TB,N
  playbackSessionPriority | Ti,N,V_playbackSessionPriority
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 20
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  playbackSessionIdentifier | types=@16@0:8
  hasPlaybackSessionIdentifier | types=B16@0:8
  hasPlaybackSessionPriority | types=B16@0:8
  hasPlaybackSessionRevision | types=B16@0:8
  playbackSessionPriority | types=i16@0:8
  playbackSessionRevision | types=@16@0:8
  setHasPlaybackSessionPriority: | types=v20@0:8B16
  setPlaybackSessionIdentifier: | types=v24@0:8@16
  setPlaybackSessionPriority: | types=v20@0:8i16
  setPlaybackSessionRevision: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRSystemPlaybackCustomDataQueueProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 2
  _data | type=@"NSData" | offset=8
  _identifier | type=@"NSString" | offset=16
PROPERTIES 2
  identifier | T@"NSString",&,N,V_identifier
  data | T@"NSData",&,N,V_data
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 14
  identifier | types=@16@0:8
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  data | types=@16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  setData: | types=v24@0:8@16
  isEqual: | types=B24@0:8@16
  setIdentifier: | types=v24@0:8@16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _MRSystemPlaybackGenericTracklistQueueProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 6
  _collectionIdentifierSet | type=@"NSData" | offset=8
  _firstTrackIdentifier | type=@"NSString" | offset=16
  _repeatMode | type=i | offset=24
  _shuffleMode | type=i | offset=28
  _trackIdentifiers | type=@"NSString" | offset=32
  _has | type={?="repeatMode"b1"shuffleMode"b1} | offset=40
PROPERTIES 10
  hasFirstTrackIdentifier | TB,R,N
  firstTrackIdentifier | T@"NSString",&,N,V_firstTrackIdentifier
  hasTrackIdentifiers | TB,R,N
  trackIdentifiers | T@"NSString",&,N,V_trackIdentifiers
  hasCollectionIdentifierSet | TB,R,N
  collectionIdentifierSet | T@"NSData",&,N,V_collectionIdentifierSet
  hasShuffleMode | TB,N
  shuffleMode | Ti,N,V_shuffleMode
  hasRepeatMode | TB,N
  repeatMode | Ti,N,V_repeatMode
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 31
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  shuffleMode | types=i16@0:8
  repeatMode | types=i16@0:8
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  readFrom: | types=B24@0:8@16
  setShuffleMode: | types=v20@0:8i16
  collectionIdentifierSet | types=@16@0:8
  firstTrackIdentifier | types=@16@0:8
  hasRepeatMode | types=B16@0:8
  hasShuffleMode | types=B16@0:8
  setHasRepeatMode: | types=v20@0:8B16
  setHasShuffleMode: | types=v20@0:8B16
  setRepeatMode: | types=v20@0:8i16
  trackIdentifiers | types=@16@0:8
  StringAsRepeatMode: | types=i24@0:8@16
  StringAsShuffleMode: | types=i24@0:8@16
  hasCollectionIdentifierSet | types=B16@0:8
  hasFirstTrackIdentifier | types=B16@0:8
  hasTrackIdentifiers | types=B16@0:8
  repeatModeAsString: | types=@20@0:8i16
  setCollectionIdentifierSet: | types=v24@0:8@16
  setFirstTrackIdentifier: | types=v24@0:8@16
  setTrackIdentifiers: | types=v24@0:8@16
  shuffleModeAsString: | types=@20@0:8i16
DIRECT_CLASS_METHODS 0

===== CLASS _MRSystemPlaybackQueueProtobuf =====
IMAGE /System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote
SUPER PBCodable
IVARS 9
  _customData | type=@"_MRSystemPlaybackCustomDataQueueProtobuf" | offset=8
  _featureName | type=@"NSString" | offset=16
  _metrics | type=@"NSData" | offset=24
  _replaceIntent | type=i | offset=32
  _tracklist | type=@"_MRSystemPlaybackGenericTracklistQueueProtobuf" | offset=40
  _type | type=i | offset=48
  _userInfo | type=@"NSData" | offset=56
  _isRequestingImmediatePlayback | type=B | offset=64
  _has | type={?="replaceIntent"b1"isRequestingImmediatePlayback"b1} | offset=68
PROPERTIES 15
  type | Ti,N,V_type
  hasReplaceIntent | TB,N
  replaceIntent | Ti,N,V_replaceIntent
  hasIsRequestingImmediatePlayback | TB,N
  isRequestingImmediatePlayback | TB,N,V_isRequestingImmediatePlayback
  hasFeatureName | TB,R,N
  featureName | T@"NSString",&,N,V_featureName
  hasCustomData | TB,R,N
  customData | T@"_MRSystemPlaybackCustomDataQueueProtobuf",&,N,V_customData
  hasTracklist | TB,R,N
  tracklist | T@"_MRSystemPlaybackGenericTracklistQueueProtobuf",&,N,V_tracklist
  hasUserInfo | TB,R,N
  userInfo | T@"NSData",&,N,V_userInfo
  hasMetrics | TB,R,N
  metrics | T@"NSData",&,N,V_metrics
DIRECT_PROTOCOLS 1
  NSCopying
DIRECT_INSTANCE_METHODS 39
  metrics | types=@16@0:8
  setUserInfo: | types=v24@0:8@16
  setMetrics: | types=v24@0:8@16
  StringAsType: | types=i24@0:8@16
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  dictionaryRepresentation | types=@16@0:8
  mergeFrom: | types=v24@0:8@16
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  featureName | types=@16@0:8
  isEqual: | types=B24@0:8@16
  setType: | types=v20@0:8i16
  type | types=i16@0:8
  hasUserInfo | types=B16@0:8
  typeAsString: | types=@20@0:8i16
  copyTo: | types=v24@0:8@16
  description | types=@16@0:8
  userInfo | types=@16@0:8
  readFrom: | types=B24@0:8@16
  customData | types=@16@0:8
  setCustomData: | types=v24@0:8@16
  hasMetrics | types=B16@0:8
  setFeatureName: | types=v24@0:8@16
  hasFeatureName | types=B16@0:8
  isRequestingImmediatePlayback | types=B16@0:8
  replaceIntent | types=i16@0:8
  setReplaceIntent: | types=v20@0:8i16
  StringAsReplaceIntent: | types=i24@0:8@16
  hasCustomData | types=B16@0:8
  hasIsRequestingImmediatePlayback | types=B16@0:8
  hasReplaceIntent | types=B16@0:8
  hasTracklist | types=B16@0:8
  replaceIntentAsString: | types=@20@0:8i16
  setHasIsRequestingImmediatePlayback: | types=v20@0:8B16
  setHasReplaceIntent: | types=v20@0:8B16
  setIsRequestingImmediatePlayback: | types=v20@0:8B16
  setTracklist: | types=v24@0:8@16
  tracklist | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _NUPlaybackRatePipeline =====
IMAGE /System/Library/PrivateFrameworks/NeutrinoCore.framework/NeutrinoCore
SUPER _NUPipeline
IVARS 1
  _enableGapFilling | type=B | offset=80
PROPERTIES 1
  enableGapFilling | TB,R,N,V_enableGapFilling
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 5
  _evaluateOutputPort:context:error: | types=@40@0:8@16@24o^@32
  alias | types=@16@0:8
  initWithIdentifier: | types=@24@0:8@16
  enableGapFilling | types=B16@0:8
  initWithGapFilling: | types=@20@0:8B16
DIRECT_CLASS_METHODS 1
  transformDescriptor | types=@16@0:8

===== CLASS _NUVideoPlaybackFrameRequestResponse =====
IMAGE /System/Library/PrivateFrameworks/NeutrinoCore.framework/NeutrinoCore
SUPER _NURenderResult
IVARS 1
  _frame | type=^{__CVBuffer=} | offset=16
PROPERTIES 6
  frame | T^{__CVBuffer=},&,V_frame
  statistics | T@"<NURenderStatistics>",R
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  NUVideoPlaybackFrameResult
DIRECT_INSTANCE_METHODS 3
  setFrame: | types=v24@0:8^{__CVBuffer=}16
  dealloc | types=v16@0:8
  frame | types=^{__CVBuffer=}16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _SFPBAudioPlaybackCardSection =====
IMAGE /System/Library/PrivateFrameworks/SearchFoundation.framework/SearchFoundation
SUPER PBCodable
IVARS 16
  _canBeHidden | type=B | offset=8
  _hasTopPadding | type=B | offset=9
  _hasBottomPadding | type=B | offset=10
  _separatorStyle | type=i | offset=12
  _state | type=i | offset=16
  _punchoutOptions | type=@"NSArray" | offset=24
  _punchoutPickerTitle | type=@"NSString" | offset=32
  _punchoutPickerDismissText | type=@"NSString" | offset=40
  _type | type=@"NSString" | offset=48
  _backgroundColor | type=@"_SFPBColor" | offset=56
  _playCommands | type=@"NSArray" | offset=64
  _stopCommands | type=@"NSArray" | offset=72
  _detailText | type=@"_SFPBRichText" | offset=80
  _title | type=@"_SFPBRichText" | offset=88
  _subtitle | type=@"_SFPBRichText" | offset=96
  _thumbnail | type=@"_SFPBImage" | offset=104
PROPERTIES 21
  punchoutOptions | T@"NSArray",C,N,V_punchoutOptions
  punchoutPickerTitle | T@"NSString",C,N,V_punchoutPickerTitle
  punchoutPickerDismissText | T@"NSString",C,N,V_punchoutPickerDismissText
  canBeHidden | TB,N,V_canBeHidden
  hasTopPadding | TB,N,V_hasTopPadding
  hasBottomPadding | TB,N,V_hasBottomPadding
  type | T@"NSString",C,N,V_type
  separatorStyle | Ti,N,V_separatorStyle
  backgroundColor | T@"_SFPBColor",&,N,V_backgroundColor
  state | Ti,N,V_state
  playCommands | T@"NSArray",C,N,V_playCommands
  stopCommands | T@"NSArray",C,N,V_stopCommands
  detailText | T@"_SFPBRichText",&,N,V_detailText
  title | T@"_SFPBRichText",&,N,V_title
  subtitle | T@"_SFPBRichText",&,N,V_subtitle
  thumbnail | T@"_SFPBImage",&,N,V_thumbnail
  jsonData | T@"NSData",R,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 2
  _SFPBAudioPlaybackCardSection
  NSSecureCoding
DIRECT_INSTANCE_METHODS 54
  setSeparatorStyle: | types=v20@0:8i16
  thumbnail | types=@16@0:8
  setThumbnail: | types=v24@0:8@16
  hasTopPadding | types=B16@0:8
  setDetailText: | types=v24@0:8@16
  initWithFacade: | types=@24@0:8@16
  hash | types=Q16@0:8
  detailText | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  jsonData | types=@16@0:8
  punchoutOptionsCount | types=Q16@0:8
  subtitle | types=@16@0:8
  state | types=i16@0:8
  clearPunchoutOptions | types=v16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  addPunchoutOptions: | types=v24@0:8@16
  initWithJSON: | types=@24@0:8@16
  setPunchoutPickerTitle: | types=v24@0:8@16
  setCanBeHidden: | types=v20@0:8B16
  isEqual: | types=B24@0:8@16
  setSubtitle: | types=v24@0:8@16
  setPunchoutPickerDismissText: | types=v24@0:8@16
  setState: | types=v20@0:8i16
  initWithDictionary: | types=@24@0:8@16
  setBackgroundColor: | types=v24@0:8@16
  setType: | types=v24@0:8@16
  type | types=@16@0:8
  backgroundColor | types=@16@0:8
  title | types=@16@0:8
  separatorStyle | types=i16@0:8
  setPunchoutOptions: | types=v24@0:8@16
  setTitle: | types=v24@0:8@16
  punchoutOptions | types=@16@0:8
  canBeHidden | types=B16@0:8
  setHasTopPadding: | types=v20@0:8B16
  punchoutPickerDismissText | types=@16@0:8
  hasBottomPadding | types=B16@0:8
  setHasBottomPadding: | types=v20@0:8B16
  punchoutOptionsAtIndex: | types=@24@0:8Q16
  punchoutPickerTitle | types=@16@0:8
  readFrom: | types=B24@0:8@16
  addPlayCommands: | types=v24@0:8@16
  addStopCommands: | types=v24@0:8@16
  clearPlayCommands | types=v16@0:8
  clearStopCommands | types=v16@0:8
  playCommands | types=@16@0:8
  playCommandsAtIndex: | types=@24@0:8Q16
  playCommandsCount | types=Q16@0:8
  setPlayCommands: | types=v24@0:8@16
  setStopCommands: | types=v24@0:8@16
  stopCommands | types=@16@0:8
  stopCommandsAtIndex: | types=@24@0:8Q16
  stopCommandsCount | types=Q16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _SFPBTrackListCardSection =====
IMAGE /System/Library/PrivateFrameworks/SearchFoundation.framework/SearchFoundation
SUPER PBCodable
IVARS 12
  _canBeHidden | type=B | offset=8
  _hasTopPadding | type=B | offset=9
  _hasBottomPadding | type=B | offset=10
  _separatorStyle | type=i | offset=12
  _punchoutOptions | type=@"NSArray" | offset=16
  _punchoutPickerTitle | type=@"NSString" | offset=24
  _punchoutPickerDismissText | type=@"NSString" | offset=32
  _type | type=@"NSString" | offset=40
  _backgroundColor | type=@"_SFPBColor" | offset=48
  _title | type=@"NSString" | offset=56
  _subtitle | type=@"NSString" | offset=64
  _tracks | type=@"NSArray" | offset=72
PROPERTIES 17
  punchoutOptions | T@"NSArray",C,N,V_punchoutOptions
  punchoutPickerTitle | T@"NSString",C,N,V_punchoutPickerTitle
  punchoutPickerDismissText | T@"NSString",C,N,V_punchoutPickerDismissText
  canBeHidden | TB,N,V_canBeHidden
  hasTopPadding | TB,N,V_hasTopPadding
  hasBottomPadding | TB,N,V_hasBottomPadding
  type | T@"NSString",C,N,V_type
  separatorStyle | Ti,N,V_separatorStyle
  backgroundColor | T@"_SFPBColor",&,N,V_backgroundColor
  title | T@"NSString",C,N,V_title
  subtitle | T@"NSString",C,N,V_subtitle
  tracks | T@"NSArray",C,N,V_tracks
  jsonData | T@"NSData",R,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 2
  _SFPBTrackListCardSection
  NSSecureCoding
DIRECT_INSTANCE_METHODS 42
  setSeparatorStyle: | types=v20@0:8i16
  hasTopPadding | types=B16@0:8
  initWithFacade: | types=@24@0:8@16
  hash | types=Q16@0:8
  tracks | types=@16@0:8
  dictionaryRepresentation | types=@16@0:8
  jsonData | types=@16@0:8
  punchoutOptionsCount | types=Q16@0:8
  subtitle | types=@16@0:8
  clearPunchoutOptions | types=v16@0:8
  writeTo: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  addPunchoutOptions: | types=v24@0:8@16
  initWithJSON: | types=@24@0:8@16
  setPunchoutPickerTitle: | types=v24@0:8@16
  setCanBeHidden: | types=v20@0:8B16
  isEqual: | types=B24@0:8@16
  setSubtitle: | types=v24@0:8@16
  setPunchoutPickerDismissText: | types=v24@0:8@16
  initWithDictionary: | types=@24@0:8@16
  setBackgroundColor: | types=v24@0:8@16
  setType: | types=v24@0:8@16
  type | types=@16@0:8
  backgroundColor | types=@16@0:8
  title | types=@16@0:8
  separatorStyle | types=i16@0:8
  setPunchoutOptions: | types=v24@0:8@16
  setTitle: | types=v24@0:8@16
  punchoutOptions | types=@16@0:8
  canBeHidden | types=B16@0:8
  setHasTopPadding: | types=v20@0:8B16
  punchoutPickerDismissText | types=@16@0:8
  hasBottomPadding | types=B16@0:8
  setHasBottomPadding: | types=v20@0:8B16
  punchoutOptionsAtIndex: | types=@24@0:8Q16
  punchoutPickerTitle | types=@16@0:8
  readFrom: | types=B24@0:8@16
  setTracks: | types=v24@0:8@16
  addTracks: | types=v24@0:8@16
  clearTracks | types=v16@0:8
  tracksAtIndex: | types=@24@0:8Q16
  tracksCount | types=Q16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _SFSiriReaderPlaybackPositionAndStateController =====
IMAGE /System/Library/Frameworks/SafariServices.framework/SafariServices
SUPER NSObject
IVARS 2
  _isPlaying | type=B | offset=8
  _stepper | type=@"<_SFSettingsAlertStepperConfiguration>" | offset=16
PROPERTIES 6
  didSetValueHandler | T@?,?,C,N
  didUpdateValues | T@?,?,C,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  _SFSettingsAlertStepperController
DIRECT_INSTANCE_METHODS 6
  .cxx_destruct | types=v16@0:8
  decrementValue: | types=v24@0:8@16
  incrementValue: | types=v24@0:8@16
  prepareStepper: | types=v24@0:8@16
  _imageForSiriIsPlaying: | types=@20@0:8B16
  resetValue: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _SFSiriReaderPlaybackRateController =====
IMAGE /System/Library/Frameworks/SafariServices.framework/SafariServices
SUPER NSObject
IVARS 1
  _playbackRate | type=f | offset=8
PROPERTIES 5
  values | T@"NSArray",R,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  _SFSettingsAlertOptionsGroupController
DIRECT_INSTANCE_METHODS 8
  values | types=@16@0:8
  accessibilityIdentifierForValue: | types=@24@0:8@16
  attributedStringForValue: | types=@24@0:8@16
  isSelectedValue: | types=B24@0:8@16
  prepareView:forItem:value: | types=v40@0:8@16@24@32
  setSelectedValue: | types=v24@0:8@16
  shouldSelectValue:forItem:groupItem: | types=B40@0:8@16@24@32
  textStyleForValue: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtC12Toolbar_CoreP33_6A8D357EAFFA0963D7B552D8BCA3C4D230DefaultToolbarTransitionHandle =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  outgoingViews | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC16WatchFeed_ECMKitP33_83BE32C1ED245D79CCFF9F4C2E34868517DeckContainerView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 4
  cutoutSize | type= | offset=416
  backgroundCardRotationDegrees | type= | offset=432
  maskedView | type= | offset=440
  maskLayer | type= | offset=448
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC17Canvas_PlayerImplP33_A3B7E5D0C6CA29BBC1860D9F8A21E49234CanvasMultiPlayerHandlerDisposable =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  onDispose | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18PhotosUIFoundationP33_245E59FB3AED492785587A094999446D42PhotosSlideTransitionTransitioningDelegate =====
IMAGE /System/Library/PrivateFrameworks/PhotosUIFoundation.framework/PhotosUIFoundation
SUPER NSObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerTransitioningDelegate
DIRECT_INSTANCE_METHODS 3
  animationControllerForPresentedController:presentingController:sourceController: | types=@40@0:8@16@24@32
  init | types=@16@0:8
  animationControllerForDismissedController: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18Search_FeatureImplP33_559EC12468D116245D704246CB34AE0722TransitionProxyControl =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIControl
IVARS 1
  action | type= | offset=464
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  initWithCoder: | types=@24@0:8@16
  handleAction | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18Search_FeatureImplP33_559EC12468D116245D704246CB34AE0729TransitionAnimatorCoordinator =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 2
  transitionAnimators | type= | offset=8
  longestTransitionAnimator | type= | offset=16
PROPERTIES 4
  state | Tq,N,R
  running | TB,N,R
  reversed | TB,N
  fractionComplete | Td,N
DIRECT_PROTOCOLS 1
  UIViewImplicitlyAnimating
DIRECT_INSTANCE_METHODS 14
  state | types=q16@0:8
  isRunning | types=B16@0:8
  isReversed | types=B16@0:8
  setReversed: | types=v20@0:8B16
  fractionComplete | types=d16@0:8
  setFractionComplete: | types=v24@0:8d16
  startAnimation | types=v16@0:8
  startAnimationAfterDelay: | types=v24@0:8d16
  pauseAnimation | types=v16@0:8
  stopAnimation: | types=v20@0:8B16
  finishAnimationAtPosition: | types=v24@0:8q16
  addCompletion: | types=v24@0:8@?16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18Search_FeatureImplP33_559EC12468D116245D704246CB34AE0733TransitionCancellationCoordinator =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  transitionContext | type= | offset=16
  cleanup | type= | offset=24
  didCancelTransition | type= | offset=40
  didCompleteTransition | type= | offset=41
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18Search_FeatureImplP33_C487A23DE67BE7155768DE3A0EC24AA925OverlappingThumbnailsView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 3
  imageLoader | type= | offset=416
  thumbnailViews | type= | offset=432
  sizeConstraints | type= | offset=440
PROPERTIES 1
  intrinsicContentSize | T{CGSize=dd},N,R
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 6
  initWithCoder: | types=@24@0:8@16
  intrinsicContentSize | types={CGSize=dd}16@0:8
  layoutSubviews | types=v16@0:8
  traitCollectionDidChange: | types=v24@0:8@16
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC18Search_FeatureImplP33_E52ECDE974C1D484AE89008E54596F3B21PlaybackStateObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 4
  playbackState | type= | offset=8
  onPlaybackStateDidChange | type= | offset=16
  uri | type= | offset=32
  player | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTPlayerObserver
DIRECT_INSTANCE_METHODS 3
  player:stateDidChange: | types=v32@0:8@16@24
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC22MultiPlayer_PlayerImplP33_3F2FFB805D7137951EFB6026A07E5B5818PreviewPlayOptions =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 10
  playWhenReady | type=B | offset=8
  initialPosition | type=d | offset=16
  endPosition | type=d | offset=24
  preferredInitialBitrate | type=Q | offset=32
  bitstreamCachingEnabled | type=B | offset=40
  automaticallyPreservesTimeOffsetFromLive | type=B | offset=41
  preventDisplaySleepDuringVideoPlayback | type=B | offset=42
  supportSmoothScrolling | type=B | offset=43
  fadeInDuration | type=d | offset=48
  activityIndicatorDisabled | type=B | offset=56
PROPERTIES 10
  playWhenReady | TB,N,R,VplayWhenReady
  initialPosition | Td,N,R,VinitialPosition
  endPosition | Td,N,R,VendPosition
  preferredInitialBitrate | TQ,N,R,VpreferredInitialBitrate
  bitstreamCachingEnabled | TB,N,R,VbitstreamCachingEnabled
  automaticallyPreservesTimeOffsetFromLive | TB,N,R,VautomaticallyPreservesTimeOffsetFromLive
  preventDisplaySleepDuringVideoPlayback | TB,N,R,VpreventDisplaySleepDuringVideoPlayback
  supportSmoothScrolling | TB,N,R,VsupportSmoothScrolling
  fadeInDuration | Td,N,R,VfadeInDuration
  activityIndicatorDisabled | TB,N,R,VactivityIndicatorDisabled
DIRECT_PROTOCOLS 1
  BMPlayOptions
DIRECT_INSTANCE_METHODS 11
  playWhenReady | types=B16@0:8
  initialPosition | types=d16@0:8
  endPosition | types=d16@0:8
  preferredInitialBitrate | types=Q16@0:8
  bitstreamCachingEnabled | types=B16@0:8
  automaticallyPreservesTimeOffsetFromLive | types=B16@0:8
  preventDisplaySleepDuringVideoPlayback | types=B16@0:8
  supportSmoothScrolling | types=B16@0:8
  fadeInDuration | types=d16@0:8
  activityIndicatorDisabled | types=B16@0:8
  init | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC23EReader_EReaderPageImplP33_E9AB78BADF9A865ED8CD1EB57F66AAAD30EReaderPlaybackGatePageContent =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 6
  playerService | type= | offset=16
  player | type= | offset=24
  closePage | type= | offset=32
  linkDispatcher | type= | offset=48
  bookUri | type= | offset=56
  openReaderOnKeepReading | type= | offset=72
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC23Recents_RecentsModelKitP33_75806B341CD0E4B71BBCE26EA9C38D2416PlaybackObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 2
  initialState | type= | offset=8
  completion | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTPlayerObserver
DIRECT_INSTANCE_METHODS 4
  player:stateDidChange: | types=v32@0:8@16@24
  player:didEncounterError: | types=v32@0:8@16@24
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC23WatchFeed_ComponentImplP33_40F911D8F279E9853BDDF9E5CFB336AF31CustomPushTransitioningDelegate =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 3
  navigationController | type= | offset=8
  originalDelegate | type= | offset=16
  animationController | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UINavigationControllerDelegate
DIRECT_INSTANCE_METHODS 10
  respondsToSelector: | types=B24@0:8:16
  forwardingTargetForSelector: | types=@24@0:8:16
  navigationController:willShowViewController:animated: | types=v36@0:8@16@24B32
  navigationController:didShowViewController:animated: | types=v36@0:8@16@24B32
  navigationControllerSupportedInterfaceOrientations: | types=Q24@0:8@16
  navigationControllerPreferredInterfaceOrientationForPresentation: | types=q24@0:8@16
  navigationController:interactionControllerForAnimationController: | types=@32@0:8@16@24
  navigationController:animationControllerForOperation:fromViewController:toViewController: | types=@48@0:8@16q24@32@40
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC24ContextMenu_InternalImplP33_9754284D7376FCB0C78534DDD04C6CA114FadeTransition =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIPercentDrivenInteractiveTransition
IVARS 3
  isPresenting | type= | offset=88
  interactive | type= | offset=89
  animatingBlock | type= | offset=96
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 5
  transitionDuration: | types=d24@0:8@16
  animateTransition: | types=v24@0:8@16
  startInteractiveTransition: | types=v24@0:8@16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC25PlaylistMixing_ElementKitP33_071FE4D55679E8C23A3257E7FBF8017642MixingReferenceTrackRowMetadataViewUpdater =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  lastSizingSignature | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC25PlaylistMixing_ElementKitP33_14F2949AEC64E71495E245996B8808839ElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 5
  view | type= | offset=8
  overlayView | type= | offset=16
  progressDotsView | type= | offset=24
  showOverlayWorkItem | type= | offset=32
  overlayBecameVisibleTime | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 2
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC25PlaylistMixing_ElementKitP33_B4A3005065FF5CC87077A83BCE4B075212TapThrottler =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  subject | type= | offset=16
  cancellable | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC25PlaylistMixing_ElementKitP33_B4A3005065FF5CC87077A83BCE4B075228RoundedCapsuleBackgroundView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtC25PlaylistMixing_ElementKitP33_C40836F12CB5FF901E1ED9D96BB0FC2F23MixingMetadataStackView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIStackView
IVARS 1
  preferredContentSizeCategoryDidChange | type= | offset=448
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 5
  init | types=@16@0:8
  initWithCoder: | types=@24@0:8@16
  traitCollectionDidChange: | types=v24@0:8@16
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_0073E89B0092C8D3C59362C27FF0AE0D21MixingEditPopAnimator =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  animator | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 6
  transitionDuration: | types=d24@0:8@16
  interruptibleAnimatorForTransition: | types=@24@0:8@16
  animateTransition: | types=v24@0:8@16
  animationEnded: | types=v20@0:8B16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_0073E89B0092C8D3C59362C27FF0AE0D22MixingEditPushAnimator =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  animator | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 6
  transitionDuration: | types=d24@0:8@16
  interruptibleAnimatorForTransition: | types=@24@0:8@16
  animateTransition: | types=v24@0:8@16
  animationEnded: | types=v20@0:8B16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_05EDA3EDA6BFDBF67C3D082C3A3310FD16MinimapElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  view | type= | offset=16
  eventHandler | type= | offset=24
  minimapCoordinator | type= | offset=40
  track | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_06B7DF640CB5952209A38826F54A571A20MixingPlayButtonView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIControl
IVARS 3
  iconView | type= | offset=464
  loadingIndicator | type= | offset=472
  displayState | type= | offset=480
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_0A274484FB2E0B4E7189B22BCFF5A78331MixingStyleCategoryTrailingView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 1
  valueLabel | type= | offset=416
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  init | types=@16@0:8
  initWithCoder: | types=@24@0:8@16
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_1EA02F7E2A996923AC9C3E91764606E618BlockContainerView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 4
  fillColor | type= | offset=416
  fillLayers | type= | offset=424
  borderLayer | type= | offset=432
  relativeBlockRanges | type= | offset=440
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  initWithCoder: | types=@24@0:8@16
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_34C155B501FFAC1918BA891A3B3FAD9B21DebouncingPlayHandler =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  player | type= | offset=16
  pendingWorkItem | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_65F2D29399F026B4BDB3A08AED098C0D25PassthroughDimmingOverlay =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 1
  onTap | type= | offset=416
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  hitTest:withEvent: | types=@40@0:8{CGPoint=dd}16@32
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_9631C1D98072A1CAD46E07BE39C996C729MixingIconTextButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 6
  fuserConnection | type= | offset=16
  dispatchEvent | type= | offset=56
  label | type= | offset=72
  iconView | type= | offset=80
  button | type= | offset=88
  longPressGesture | type= | offset=96
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 1
  handleLongPress: | types=v24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtC27PlaylistMixing_MixingUIImplP33_BDF4826A5750025167E538B1D96B374726ProductOptInPromoElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  view | type= | offset=16
  titleLabel | type= | offset=24
  bodyLabel | type= | offset=32
  primaryButton | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC28PlaylistMixing_MessagingImplP33_DBAD203173ADEE94122C521952F7529810BulletView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 2
  bullet | type= | offset=416
  bodyLabel | type= | offset=424
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  init | types=@16@0:8
  initWithCoder: | types=@24@0:8@16
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC28PlaylistMixing_MessagingImplP33_DBAD203173ADEE94122C521952F7529817SquareBulletLabel =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 1
  encoreLabel | type= | offset=416
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 5
  init | types=@16@0:8
  initWithCoder: | types=@24@0:8@16
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC31NowPlaying_MixingTransitionImplP33_9842B30F24957717BA260D68CD049B1A28CustomAnimationImageProvider =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 3
  firstImage | type= | offset=16
  secondImage | type= | offset=24
  fallback | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC32PlaylistMixing_ListUXPluginsImplP33_58C6B4B9285033A139F7E7C3B67FC06529NoOpShuffleToggleUpsellLogger =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTShuffleToggleUpsellPresentationLogger
DIRECT_INSTANCE_METHODS 2
  logHitShuffleButton | types=@16@0:8
  init | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC33EpisodePage_ModernEpisodePageImplP33_67158F97BBD5C63EA54E7CBDADF855D518PlaybackDataHolder =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  latestData | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC36MarkAsPlayed_MarkAsPlayedManagerImplP33_2333C46821EBB5BDDA249B537061FB7C16PlaybackObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 3
  expectedChapterURI | type= | offset=8
  onChapterStarted | type= | offset=24
  hasTriggered | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTPlayerObserver
DIRECT_INSTANCE_METHODS 3
  player:stateDidChange: | types=v32@0:8@16@24
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC37MultiPlayer_UserSelectedMuteStateImplP33_3FE6F6B86CD4CD192361585FE42E190B21ContextPlayerObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  consumer | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTPlayerObserver
DIRECT_INSTANCE_METHODS 3
  player:stateDidChange: | types=v32@0:8@16@24
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC37MultiPlayer_UserSelectedMuteStateImplP33_E63A39A39AE7261FCBB5F5845603874220ConnectStateObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  consumer | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTConnectAggregatorStateObserver
DIRECT_INSTANCE_METHODS 1
  aggregator:didUpdateAggregatorState: | types=v32@0:8@16@24
DIRECT_CLASS_METHODS 0

===== CLASS _TtC38PlaylistMixing_LaterInPlaylistPageImplP33_86B34723FEC63B53198E72BCDEED5E5F29LaterInPlaylistReferenceRowUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  referenceRowView | type= | offset=16
  $__lazy_storage_$_view | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC40ListeningParties_PlaybackCoordinatorImplP33_274DF539F153BA35A17E1D5E383BC10425DispatchSourceBufferTimer =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  source | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC41SocialListeningPartnerIntegrations_ECMKitP33_9B710C0B6B96240437DB6BFC36204E0223OverlappingLogoMaskView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 3
  cutoutDiameter | type= | offset=416
  overlap | type= | offset=424
  maskLayer | type= | offset=432
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  initWithCoder: | types=@24@0:8@16
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC44MusicPlaybackSpeed_SpeedControlMessagingImplP33_5DC548D1F233808CF3B36C3909B1B56230SpeedControlMessagingElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 5
  view | type= | offset=16
  titleLabel | type= | offset=24
  bodyLabel | type= | offset=32
  primaryButton | type= | offset=40
  secondaryButton | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC44MusicPlaybackSpeed_SpeedControlMessagingImplP33_D4DC162028777FB81DF32D962C2694C713ImageLoadable =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  url | type= | offset=16
  size | type= | offset=32
  imageLoader | type= | offset=48
  imageLoadTask | type= | offset=64
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC44MusicPlaybackSpeed_SpeedControlMessagingImplP33_D4DC162028777FB81DF32D962C2694C719SingleImageLoadTask =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  task | type= | offset=16
  isComplete | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC46CoreMediaRenderer_CmrVideoSurfaceInstallerImplP33_52716651845F435A56A1BAA4E12DA3AA19CmrPlaybackIdentity =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 4
  sessionId | type= | offset=8
  mediaUrl | type= | offset=24
  metadata | type= | offset=40
  $__lazy_storage_$_betamaxIdentity | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 2
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC46CoreMediaRenderer_CmrVideoSurfaceInstallerImplP33_52716651845F435A56A1BAA4E12DA3AA26CmrBetamaxPlaybackIdentity =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 6
  sessionID | type=? | offset=8
  shouldReportStream | type=B | offset=24
  hasExternalReporter | type=B | offset=25
  mediaURL | type= | offset=32
  metadata | type=? | offset=48
  isAudioOnlyAllowed | type=B | offset=56
PROPERTIES 6
  sessionID | T@"NSString",N,R
  shouldReportStream | TB,N,R,VshouldReportStream
  hasExternalReporter | TB,N,R,VhasExternalReporter
  mediaURL | T@"NSURL",N,R
  metadata | T@"NSDictionary",N,R
  isAudioOnlyAllowed | TB,N,R,VisAudioOnlyAllowed
DIRECT_PROTOCOLS 1
  BMPlaybackIdentity
DIRECT_INSTANCE_METHODS 8
  sessionID | types=@16@0:8
  shouldReportStream | types=B16@0:8
  hasExternalReporter | types=B16@0:8
  mediaURL | types=@16@0:8
  metadata | types=@16@0:8
  isAudioOnlyAllowed | types=B16@0:8
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC46MusicPlaybackSpeed_SpeedControlBottomSheetImplP33_6357C7D72F87E64091C586BF1F20E66029ExplicitContentBridgeObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  onChange | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTExplicitContentEnabledStateObserver
DIRECT_INSTANCE_METHODS 3
  explicitContentEnabledStateDidChange: | types=v20@0:8B16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC46MusicPlaybackSpeed_SpeedControlBottomSheetImplP33_DD46140109B3F6FBA96B08715A1B7C0C29AgeVerificationBridgeObserver =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  onChange | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  AgeVerification_DialogAPI.SPTCanPlayAgeRestrictedContentStateObserver
DIRECT_INSTANCE_METHODS 3
  didChangeCanPlayAgeRestrictedContent: | types=v20@0:8B16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC46MusicPlaybackSpeed_SpeedControlBottomSheetImplP33_DE311892AD0C81423D6917ED9CBACACA21SpeedPreviewElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  eventHandler | type= | offset=16
  $__lazy_storage_$_previewButton | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 1
  previewTapped | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_0687F7F3C6FB6408E2C31A698725803038ParentalConsentMessageContentElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 3
  view | type= | offset=16
  titleLabel | type= | offset=24
  subtitleLabel | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_292DE6EB0ECF3F2191A1A555E719AE2334WaitingRoomTimeoutMessageElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  view | type= | offset=16
  title | type= | offset=24
  subtitle | type= | offset=32
  button | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_468482561D8D1A42875384ECF7368A1D33WaitingRoomFailureButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  view | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_52A6F4502FD769B2A2B1CB79756B7D6627LoginOptionsButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  view | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_66344740A6396818F32056BEF545AB5F34WaitingRoomFailureMessageElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  view | type= | offset=16
  subtitle | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_B072A171E8CEC9A9C8E5A9C31149F38B34WaitingRoomLoadingMessageElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 3
  view | type= | offset=16
  title | type= | offset=24
  subtitle | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC58GenAlphaAccountCreation_KidAccountTransitionSubmitPageImplP33_BAF2A94C682244800A97078A9B0D25F433WaitingRoomTimeoutButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  view | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC59GenAlphaAccountCreation_KidAccountTransitionConsentPageImplP33_1611C86DF43BEDF6FBA0CB1CA779CAEA35KidAccountTransitionFooterElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  view | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC59GenAlphaAccountCreation_KidAccountTransitionConsentPageImplP33_3923E20F9B35FFB29676AF77A9539B6B39KidAccountTransitionNextButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  view | type= | offset=16
  button | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC59GenAlphaAccountCreation_KidAccountTransitionConsentPageImplP33_3D7958EBB3AE9D058D65873E5976A06546KidAccountTransitionModernDescriptionElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  view | type= | offset=16
  whatWillChangeList | type= | offset=24
  whatWillStaySameList | type= | offset=32
  undoNotice | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC59GenAlphaAccountCreation_KidAccountTransitionConsentPageImplP33_AE3D505D62972783FF4D37834ACC15EA35KidAccountTransitionAvatarElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 3
  view | type= | offset=16
  avatar | type= | offset=24
  label | type= | offset=32
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC5UIKitP33_F084B5C1489DDF8EC47531A7840D5DBB25_UITransitionBackdropView =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER UIView
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 2
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
DIRECT_CLASS_METHODS 1
  layerClass | types=#16@0:8

===== CLASS _TtC61SubscriptionManagement_RegularMemberSubAccountDetailsPageImplP33_01049D795E33CC026AF96747206AB88926TransitionAccountElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  view | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtC7SwiftUIP33_7AAD2D5A795A4A45B166E98EE1EE124726AnyNavigationTransitionBox =====
IMAGE /System/Library/Frameworks/SwiftUI.framework/SwiftUI
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC13BetamaxSDKAPI22PlaybackRequestFactoryP33_D84ACD925BDAD37D9EFF9097F93EA1D619PlaybackRequestImpl =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 5
  mediaURL | type= | offset=8
  metadata | type=? | offset=24
  isAudioOnlyAllowed | type=B | offset=32
  shouldReportStream | type=B | offset=33
  hasExternalReporter | type=B | offset=34
PROPERTIES 7
  mediaURL | T@"NSURL",N,R
  metadata | T@"NSDictionary",N,R
  isAudioOnlyAllowed | TB,N,R,VisAudioOnlyAllowed
  shouldReportStream | TB,N,R,VshouldReportStream
  hasExternalReporter | TB,N,R,VhasExternalReporter
  hash | Tq,N,R
  description | T@"NSString",N,R
DIRECT_PROTOCOLS 1
  BMPlaybackRequest
DIRECT_INSTANCE_METHODS 11
  mediaURL | types=@16@0:8
  metadata | types=@16@0:8
  isAudioOnlyAllowed | types=B16@0:8
  shouldReportStream | types=B16@0:8
  hasExternalReporter | types=B16@0:8
  copyWithZone: | types=@24@0:8^v16
  hash | types=q16@0:8
  isEqual: | types=B24@0:8@16
  description | types=@16@0:8
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC14SiriTTSService14AVSBARPlaybackP33_4791274A894FA1CB92EFFF8F61E0C16D21AudioMappedInfoAVSBAR =====
IMAGE /System/Library/PrivateFrameworks/SiriTTSService.framework/SiriTTSService
SUPER _TtCs12_SwiftObject
IVARS 6
  sampleBuffer | type= | offset=16
  audioBytesRange | type= | offset=24
  packetCount | type= | offset=40
  packetDescriptionsRange | type= | offset=48
  endOfSiriTTSUtterance | type= | offset=64
  finishCallback | type= | offset=72
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC15GroupActivities14PlaybackSyncer27AVCoordinatorDelegateBridge =====
IMAGE /System/Library/Frameworks/GroupActivities.framework/GroupActivities
SUPER NSObject
IVARS 2
  localParticipantID | type= | offset=8
  delegate | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 2
  AVPlaybackCoordinationMediumDelegatePrivate
  AVPlaybackCoordinationMediumDelegate
DIRECT_INSTANCE_METHODS 7
  .cxx_destruct | types=v16@0:8
  init | types=@16@0:8
  localParticipantUUIDForPlaybackCoordinator: | types=@24@0:8@16
  playbackCoordinator:broadcastLocalParticipantStateDictionary: | types=v32@0:8@16@24
  playbackCoordinator:broadcastTransportControlStateDictionary:forItemWithIdentifier: | types=v40@0:8@16@24@32
  playbackCoordinator:reloadTransportControlStateForItemWithIdentifier:completionHandler: | types=v40@0:8@16@24@?32
  playbackCoordinator:promptForLeaveOrEndSessionAllowingCancellation:completionHandler: | types=v36@0:8@16B24@?28
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC22MultiPlayer_PlayerImpl15MultiPlayerImplP33_5DC40F581CEA7B174923B1A63F77223E14CurrentContext =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  session | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC22MultiPlayer_PlayerImpl15PlayerGroupImplP33_EDACFB8F48EE3A3F36E0A467DE3648605Scope =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  tokens | type= | offset=16
  playerPool | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC26AccessibilitySharedSupport13AXSoundPlayerP33_1A7FE478347CA6649B7841ED7444701115PlaybackContext =====
IMAGE /System/Library/PrivateFrameworks/AccessibilitySharedSupport.framework/AccessibilitySharedSupport
SUPER _TtCs12_SwiftObject
IVARS 7
  audioQueue | type= | offset=16
  logger | type= | offset=24
  playerNode | type= | offset=32
  repeatInterval | type= | offset=40
  repeatTimer | type= | offset=48
  nextStartFrame | type= | offset=56
  isRepeating | type= | offset=64
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC27PlaylistMixing_MixingUIImpl24MixingEditViewControllerP33_F2E9488B2A873881953E05A603EAAFCC20BetaTagBarButtonView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 2
  tagView | type= | offset=416
  tagSize | type= | offset=424
PROPERTIES 1
  intrinsicContentSize | T{CGSize=dd},N,R
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  initWithCoder: | types=@24@0:8@16
  intrinsicContentSize | types={CGSize=dd}16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC31MData_PlaybackTraitExtensionKit13PlaybackTrait14PlaybackOffset =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  start | type= | offset=16
  end | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC32ExternalIntegration_PlaybackImpl16PlaybackProviderP33_8EC4D7FE915E3D83EB048CBC877BB82413PlayerRequest =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  task | type= | offset=16
  completionHandler | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC38PlaybackControl_AudioVideoSwitcherImpl28VideoAgeAssuranceMonitorImplP33_D51A6B4FBF84678B2CCB38BA8A536D867Waiters =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 1
  continuations | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC39ListeningParties_NowPlayingViewModeImpl38NowPlayingLiveRoomContextMenuPresenter22PlaybackSettingsAction =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  viewController | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  SPTContextMenuAction
DIRECT_INSTANCE_METHODS 6
  title | types=@16@0:8
  icon | types=@16@0:8
  performAction | types=@16@0:8
  style | types=q16@0:8
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC46CoreMediaRenderer_CmrVideoSurfaceInstallerImpl24CmrVideoSurfaceInstallerP33_52716651845F435A56A1BAA4E12DA3AA14ActivePlayback =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 8
  playbackId | type= | offset=16
  mediaUrl | type= | offset=32
  trackUri | type= | offset=48
  trackUid | type= | offset=64
  sessionId | type= | offset=80
  identity | type= | offset=96
  attachedSurface | type= | offset=104
  renderable | type= | offset=112
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC5AVKit24AVMultiviewWindowManager23TransitionConfiguration =====
IMAGE /System/Library/Frameworks/AVKit.framework/AVKit
SUPER _TtCs12_SwiftObject
IVARS 6
  _transitioningToExperience | type= | offset=16
  _placement | type= | offset=24
  _originalAVPVC | type= | offset=56
  _originatorIndex | type= | offset=64
  _indexToFullscreen | type= | offset=72
  _$observationRegistrar | type= | offset=80
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC5UIKit32NavigationBarTransitionContainer16InteractingModel =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _TtCs12_SwiftObject
IVARS 2
  _isInteracting | type= | offset=16
  _$observationRegistrar | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC5UIKit32NavigationBarTransitionContainer8Animator =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _TtCs12_SwiftObject
IVARS 2
  defaultAnimation | type= | offset=16
  animationKind | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC5UIKit34_UILightEffectTransitionControllerP33_2ED668DD1C0D8968A321F2B9D51C08016Handle =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _TtCs12_SwiftObject
IVARS 2
  transitionID | type= | offset=16
  owner | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCC5UIKitP33_1224E733E1875C87E73DF2A91211E8CE36_IntelligenceLightSourceFillProvider14TransitionView =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER UIKit._UIMaterialDefinitionView
IVARS 4
  lightSource | type= | offset=424
  handle | type= | offset=432
  visibilityKeyPath | type= | offset=440
  lightSourceView | type= | offset=448
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 4
  layoutSubviews | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtCCE5UIKitCSo16UIViewController17TransitionManager5Entry =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _TtCs12_SwiftObject
IVARS 6
  manager | type= | offset=16
  viewController | type= | offset=24
  state | type= | offset=32
  children | type= | offset=40
  runningTransition | type= | offset=48
  externalTransitioningEntries | type= | offset=56
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCCV44PlaylistArtwork_EditPlaylistCoverArtPageImpl24EditPlaylistCoverArtPageP33_05B278CEAE32A5D391E963D4B68F7CB821TransitioningDelegate32FullScreenPresentationController =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIPresentationController
IVARS 0
PROPERTIES 1
  shouldRemovePresentersView | TB,N,R
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  shouldRemovePresentersView | types=B16@0:8
  containerViewWillLayoutSubviews | types=v16@0:8
  initWithPresentedViewController:presentingViewController: | types=@32@0:8@16@24
DIRECT_CLASS_METHODS 0

===== CLASS _TtCE16LinkPresentationCSo35LPCustomizationPickerViewController18TransitionAnimator =====
IMAGE /System/Library/Frameworks/LinkPresentation.framework/LinkPresentation
SUPER NSObject
IVARS 2
  viewController | type= | offset=8
  reversed | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 4
  animateTransition: | types=v24@0:8@16
  transitionDuration: | types=d24@0:8@16
  .cxx_destruct | types=v16@0:8
  init | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCE17RealityFoundationC10RealityKit23AudioPlaybackController8Internal =====
IMAGE /System/Library/Frameworks/RealityFoundation.framework/RealityFoundation
SUPER _TtCs12_SwiftObject
IVARS 9
  playerComponent | type= | offset=16
  entity | type= | offset=24
  resource | type= | offset=32
  playbackController | type= | offset=40
  playbackToken | type= | offset=48
  internalAudioUnit | type= | offset=56
  stateChangeSubscriptionHandle | type= | offset=64
  audioUnitPreparedSubscriptionHandle | type= | offset=88
  completionHandler | type= | offset=112
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCE23Reprise_ChatInputRowKitO15Reprise_CoreKit7Reprise27OverlappingButtonsStackView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIStackView
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  hitTest:withEvent: | types=@40@0:8{CGPoint=dd}16@32
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _TtCE39PlaylistMixing_WatchFeedIntegrationImplOE16WatchFeed_ECMKitO19LegacyUI_ECMCoreKit5Views10Components28SimpleEntityRowComponentView =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIView
IVARS 3
  viewModel | type= | offset=416
  $__lazy_storage_$_titleLabel | type= | offset=448
  $__lazy_storage_$_subtitleLabel | type= | offset=456
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCE5UIKitCSo16UIViewController17TransitionManager =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _TtCs12_SwiftObject
IVARS 1
  rootEntries | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO27PodcastPlaybackSpeed_ECMKit26PodcastDialogPlaybackSpeed11RoundButton =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIButton
IVARS 1
  tapAnimationScaleFactor | type= | offset=752
PROPERTIES 1
  highlighted | TB,N
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 6
  isHighlighted | types=B16@0:8
  setHighlighted: | types=v20@0:8B16
  layoutSubviews | types=v16@0:8
  initWithFrame: | types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  initWithCoder: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl24SimpleEntityRowComponent10ViewBinder =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 5
  ubiEventLogger | type= | offset=16
  ubiImpressionToken | type= | offset=32
  model | type= | offset=48
  componentState | type= | offset=80
  viewController | type= | offset=88
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl24SimpleEntityRowComponent14ViewController =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIViewController
IVARS 3
  viewModel | type= | offset=1008
  $__lazy_storage_$_componentView | type= | offset=1040
  viewBinder | type= | offset=1048
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 5
  initWithNibName:bundle: | types=@32@0:8@16@24
  initWithCoder: | types=@24@0:8@16
  loadView | types=v16@0:8
  viewDidLoad | types=v16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl24SimpleEntityRowComponent15ComponentBinder =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl36ChapterNavigationListButtonComponent10ViewBinder =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 7
  viewController | type= | offset=16
  ubiEventLogger | type= | offset=24
  consumers | type= | offset=40
  ubiImpressionToken | type= | offset=56
  ubiSheetImpressionToken | type= | offset=72
  model | type= | offset=88
  componentState | type= | offset=128
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl36ChapterNavigationListButtonComponent14ViewController =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER UIViewController
IVARS 5
  viewModel | type= | offset=1008
  presentedSheetVC | type= | offset=1080
  onSheetDismissed | type= | offset=1088
  $__lazy_storage_$_iconButton | type= | offset=1104
  viewBinder | type= | offset=1112
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIAdaptivePresentationControllerDelegate
DIRECT_INSTANCE_METHODS 6
  presentationControllerDidDismiss: | types=v24@0:8@16
  initWithNibName:bundle: | types=@32@0:8@16@24
  initWithCoder: | types=@24@0:8@16
  loadView | types=v16@0:8
  viewDidLoad | types=v16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl36ChapterNavigationListButtonComponent15ComponentBinder =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCOC5AVKit32InputPickerTransitioningDelegate17PresentationStyle10AnchorInfo =====
IMAGE /System/Library/Frameworks/AVKit.framework/AVKit
SUPER _TtCs12_SwiftObject
IVARS 2
  sourceView | type= | offset=16
  animationCoordinator | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV10PegasusAPI41Searchfoundation_AudioPlaybackCardSectionP33_46860A08F4AFD7D98A2A4EE4ED4BF33B13_StorageClass =====
IMAGE /System/Library/PrivateFrameworks/PegasusAPI.framework/PegasusAPI
SUPER _TtCs12_SwiftObject
IVARS 16
  _punchoutOptions | type= | offset=16
  _punchoutPickerTitle | type= | offset=24
  _punchoutPickerDismissText | type= | offset=40
  _canBeHidden | type= | offset=56
  _hasTopPadding_p | type= | offset=57
  _hasBottomPadding_p | type= | offset=58
  _type | type= | offset=64
  _separatorStyle | type= | offset=80
  _backgroundColor | type= | offset=96
  _state | type= | offset=120
  _playCommands | type= | offset=136
  _stopCommands | type= | offset=144
  _detailText | type= | offset=152
  _title | type= | offset=264
  _subtitle | type= | offset=376
  _thumbnail | type= | offset=488
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV10SwiftMedia8URLAsset18PlaybackController =====
IMAGE /System/Library/PrivateFrameworks/SwiftMedia.framework/SwiftMedia
SUPER _TtCs12_SwiftObject
IVARS 18
  loggingIdentifier | type= | offset=16
  isolation | type= | offset=32
  snapshot | type= | offset=48
  snapshotContinuations | type= | offset=112
  notificationContinuation | type= | offset=120
  notificationProcessingTask | type= | offset=128
  _didStopPlaybackCallback | type= | offset=136
  _requestValuesReapplyCallback | type= | offset=152
  lastAppliedValues | type= | offset=168
  wasRecycled | type= | offset=278
  asset | type= | offset=280
  audioSessionManager | type= | offset=312
  lastAppliedAudioSessionID | type= | offset=328
  cachedCurrentTime | type= | offset=336
  figAssetWrapper | type= | offset=368
  _figPlayerWrapper | type= | offset=376
  figPlayerObserver | type= | offset=384
  figPlaybackItemWrapper | type= | offset=392
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV17PhotosSwiftUICore38PhotosInlinePlaybackDebugVisualization6Player =====
IMAGE /System/Library/PrivateFrameworks/PhotosSwiftUICore.framework/PhotosSwiftUICore
SUPER _TtCs12_SwiftObject
IVARS 3
  _desiredInlinePlayState | type= | offset=16
  _onPlaybackFinished | type= | offset=24
  _$observationRegistrar | type= | offset=40
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl17MediaPlaybackPlayP33_83033F21E9372B351E60667C5BAEBAF313_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 25
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl18MediaPlaybackErrorP33_327811BFE013F6064F8C3257B824215813_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 29
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _errorType | type= | offset=296
  _severity | type= | offset=312
  _errorCode | type= | offset=328
  _errorMessage | type= | offset=336
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl18MediaPlaybackPauseP33_F68D9B493E5B04EB51283626B3782C0213_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 25
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl19MediaPlaybackBeaconP33_89343DBC5F8F53543898C541D783F80313_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 32
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _reason | type= | offset=296
  _beginTrackingTimestamp | type= | offset=312
  _timeSinceLastHeartbeat | type= | offset=328
  _renderedFrames | type= | offset=344
  _droppedFrames | type= | offset=360
  _videoDecoderName | type= | offset=376
  _audioDecoderName | type= | offset=392
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl20MediaPlaybackSeekEndP33_575466163FFF4DFAA50D9C1FAB3BEEE813_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 27
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _seekStartPosition | type= | offset=296
  _seekEndPosition | type= | offset=312
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl21MediaPlaybackStallEndP33_C26E40C3A5B061D557E711DFBA74CE5313_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 28
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _bufferType | type= | offset=296
  _initSegmentSource | type= | offset=312
  _startupSegmentsSource | type= | offset=328
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl22MediaPlaybackSeekStartP33_686C6AA04E69EBF0F48F418FAEFFED1013_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 27
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _seekStartPosition | type= | offset=296
  _seekEndPosition | type= | offset=312
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl23MediaPlaybackStallStartP33_335A0BD4B1143D4B643C55997BA7C77413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 26
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _bufferType | type= | offset=296
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl26MediaPlaybackProfileChangeP33_EF3DB4DE4EDC722854F6E6692ADF4DF813_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 39
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _viewingDisplayWidth | type= | offset=292
  _viewingDisplayHeight | type= | offset=300
  _encodedDisplayWidth | type= | offset=308
  _encodedDisplayHeight | type= | offset=316
  _avgBitrateAudio | type= | offset=324
  _maxBitrateAudio | type= | offset=332
  _avgBitrateVideo | type= | offset=340
  _maxBitrateVideo | type= | offset=348
  _audioCodec | type= | offset=360
  _videoCodec | type= | offset=376
  _frameRate | type= | offset=392
  _audioProfileID | type= | offset=400
  _videoProfileID | type= | offset=416
  _type | type= | offset=432
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl30MediaPlaybackInitializationEndP33_C2863B640C40F17E275B70C03582CC3F13_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 26
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _manifestSource | type= | offset=296
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25Betamax_ObservabilityImpl32MediaPlaybackInitializationStartP33_CFDA802E0E5E5EE62012A233A291E7D613_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 28
  _mediaURL | type= | offset=16
  _featureIdentifier | type= | offset=32
  _playbackID | type= | offset=48
  _sessionID | type= | offset=64
  _mediaType | type= | offset=80
  _playerType | type= | offset=96
  _mediaDuration | type= | offset=112
  _isPlaying | type= | offset=121
  _playerPosition | type= | offset=128
  _subtitleLanguage | type= | offset=144
  _speed | type= | offset=160
  _volume | type= | offset=168
  _networkState | type= | offset=176
  _bitrate | type= | offset=192
  _playbackDestination | type= | offset=200
  _isAudioOnly | type= | offset=216
  _streamingType | type= | offset=224
  _surface | type= | offset=240
  _battery | type= | offset=256
  _isPowerSaverActive | type= | offset=261
  _isBackgrounded | type= | offset=262
  _isVideoDisabled | type= | offset=263
  _subtitlesActive | type= | offset=264
  _sequenceNumber | type= | offset=268
  _createdTime | type= | offset=280
  _spotifyUri | type= | offset=296
  _playContext | type= | offset=312
  _playbackOrchestration | type= | offset=328
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV25PlaylistMixing_ElementKit16MixButtonElementP33_BE0763CFCD06B428D942AA9CCDC74F259ElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  view | type= | offset=16
  buttonView | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV26UBI_NavigationTrackingImpl29UbiProd1PageTransitionNonAuthP33_8981E626684BBBC0B6C07B07324F9ABD13_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 28
  _pageInstanceID | type= | offset=16
  _pageID | type= | offset=32
  _entityUri | type= | offset=48
  _navigationalRoot | type= | offset=64
  _fromPageInstanceID | type= | offset=80
  _fromPageID | type= | offset=96
  _fromEntityUri | type= | offset=112
  _fromNavigationalRoot | type= | offset=128
  _navigationReason | type= | offset=144
  _previousInteractionIds | type= | offset=160
  _errors | type= | offset=168
  _flowID | type= | offset=176
  _clientTimezone | type= | offset=192
  _transitionStartTimestamp | type= | offset=208
  _sceneID | type= | offset=224
  _pagePresentationID | type= | offset=240
  _pathNames | type= | offset=248
  _pathPos | type= | offset=256
  _pathIds | type= | offset=264
  _pathUris | type= | offset=272
  _pathReasons | type= | offset=280
  _pathSpecificationVersions | type= | offset=288
  _errorsDetected | type= | offset=296
  _branchingSourcePageInstanceID | type= | offset=304
  _appInstanceID | type= | offset=320
  _appVisitIndex | type= | offset=336
  _feature | type= | offset=344
  _pageIdentifier | type= | offset=360
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV27PlaylistMixing_MixingUIImpl18MixingPagerElement14PagerElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 12
  eventHandler | type= | offset=8
  view | type= | offset=24
  $__lazy_storage_$_pageControl | type= | offset=32
  $__lazy_storage_$_collectionView | type= | offset=40
  renderer | type= | offset=48
  bottomSheetElement | type= | offset=56
  $__lazy_storage_$_scrollHandler | type= | offset=200
  _containerItems | type= | offset=216
  latestState | type= | offset=232
  contentSizeObservation | type= | offset=304
  $__lazy_storage_$_pageControlDiffuser | type= | offset=312
  $__lazy_storage_$_pagerPresenterDiffuser | type= | offset=328
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  pageControlValueChanged: | types=v24@0:8@16
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV27PlaylistMixing_MixingUIImpl21MixingPlayHeadElementP33_C523A9664157F6B7591611F315A808AD9ElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  playHead | type= | offset=16
  previousState | type= | offset=24
  animator | type= | offset=160
  trajectory | type= | offset=168
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV27PlaylistMixing_MixingUIImpl23MixingPlayButtonElementP33_06B7DF640CB5952209A38826F54A571A25CustomPlayButtonElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 2
  view | type= | offset=16
  showLoaderWorkItem | type= | offset=24
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV27PlaylistMixing_MixingUIImpl30MixingBottomSheetPickerElementP33_F6E0A06DE39740C495DB3F86EA57D21516DefaultElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 9
  eventHandler | type= | offset=16
  view | type= | offset=32
  descriptionLabel | type= | offset=40
  scrollView | type= | offset=48
  optionButtons | type= | offset=56
  lastPickerTypeHash | type= | offset=64
  scrollPositions | type= | offset=72
  lastSelectedId | type= | offset=80
  currentSelectedIndex | type= | offset=96
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV27PlaylistMixing_MixingUIImpl33MixingBottomSheetContainerElementP33_2F1C4DD5F6CEDC3F2766B0E31CB0E2F29ElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 9
  eventHandler | type= | offset=16
  availableStylesProvider | type= | offset=32
  descriptionLabel | type= | offset=72
  presentedPicker | type= | offset=80
  contentElementView | type= | offset=88
  $__lazy_storage_$_grabber | type= | offset=96
  $__lazy_storage_$_separator | type= | offset=104
  $__lazy_storage_$_view | type= | offset=112
  previousUIConfiguration | type= | offset=120
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV28PlaylistMixing_MessagingImpl42MixingMessagingNonBeatMatchedTracksElementP33_DBAD203173ADEE94122C521952F752989ElementUI =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 7
  view | type= | offset=16
  eventHandler | type= | offset=24
  titleLabel | type= | offset=40
  primaryButton | type= | offset=48
  secondaryButton | type= | offset=56
  bodyLabel | type= | offset=64
  bulletPointsStackView | type= | offset=72
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV34SwiftEsperanto_preview_proto_swift29Spotify_Automix_Proto_PreviewP33_5D34A261577B2A79CEF60060D0F4579B13_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 15
  _trackUri1 | type= | offset=16
  _trackUri2 | type= | offset=32
  _automixMode | type= | offset=48
  _transitionUri | type= | offset=64
  _startPositionMs | type= | offset=80
  _relativeStartPosition | type= | offset=88
  _cuepoints | type= | offset=96
  _stopPositionMs | type= | offset=240
  _transitionRecipe | type= | offset=256
  _playableTrackUri1 | type= | offset=344
  _playableTrackUri2 | type= | offset=360
  _contextUri | type= | offset=376
  _armID | type= | offset=392
  _itemSpeedA | type= | offset=408
  _itemSpeedB | type= | offset=416
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV37SwiftEsperanto_transition_proto_swift28Spotify_Automix_Proto_PresetP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 17
  _id | type= | offset=16
  _type | type= | offset=24
  _volumeStyleOverride | type= | offset=40
  _eqStyleOverride | type= | offset=64
  _filterFxStyleOverride | type= | offset=88
  _volumeOutCurveOverride | type= | offset=112
  _volumeInCurveOverride | type= | offset=152
  _eqOutCurveOverrides | type= | offset=192
  _eqInCurveOverrides | type= | offset=328
  _filterOutCurveOverrides | type= | offset=464
  _filterInCurveOverrides | type= | offset=600
  _fxStyleOverride | type= | offset=736
  _fxOutCurveOverrides | type= | offset=760
  _fxInCurveOverrides | type= | offset=896
  _jogwheelStyleOverride | type= | offset=1032
  _loopingStyleOverride | type= | offset=1056
  _loopingOutBlocksOverride | type= | offset=1080
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV37SwiftEsperanto_transition_proto_swift29Spotify_Automix_Proto_OverlapP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 19
  _trackARowID | type= | offset=16
  _trackBRowID | type= | offset=32
  _startAMs | type= | offset=48
  _startBMs | type= | offset=52
  _durationMs | type= | offset=56
  _speedA | type= | offset=60
  _speedB | type= | offset=68
  _durationBars | type= | offset=76
  _isBeatmatched | type= | offset=81
  _trackAUri | type= | offset=88
  _trackBUri | type= | offset=104
  _trackAPlayableUri | type= | offset=120
  _trackBPlayableUri | type= | offset=136
  _trackAPlayableBeatsHash | type= | offset=152
  _trackBPlayableBeatsHash | type= | offset=168
  _bpmA | type= | offset=184
  _bpmB | type= | offset=188
  _itemSpeedA | type= | offset=192
  _itemSpeedB | type= | offset=200
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV37SwiftEsperanto_transition_proto_swift35Spotify_Automix_Proto_EqStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 7
  _style | type= | offset=16
  _lowEqOutCurves | type= | offset=40
  _midEqOutCurves | type= | offset=80
  _highEqOutCurves | type= | offset=120
  _lowEqInCurves | type= | offset=160
  _midEqInCurves | type= | offset=200
  _highEqInCurves | type= | offset=240
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV37SwiftEsperanto_transition_proto_swift35Spotify_Automix_Proto_FxStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 7
  _style | type= | offset=16
  _echoDryWetOutCurves | type= | offset=40
  _echoDryWetInCurves | type= | offset=80
  _reverbDryWetOutCurves | type= | offset=120
  _reverbDryWetInCurves | type= | offset=160
  _delayDryWetOutCurves | type= | offset=200
  _delayDryWetInCurves | type= | offset=240
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV37SwiftEsperanto_transition_proto_swift41Spotify_Automix_Proto_FilterFxStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 7
  _style | type= | offset=16
  _filterCutoffOutCurves | type= | offset=40
  _filterResonanceOutCurves | type= | offset=80
  _filterCutoffInCurves | type= | offset=120
  _filterResonanceInCurves | type= | offset=160
  _noiseColorOutCurves | type= | offset=200
  _noiseColorInCurves | type= | offset=240
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV39PlaylistEditing_PlaylistHistoryProtoKit37EntityHistory_CustomTransitionChangedP33_0C153D3BE8B30B44F4A8253FF023554813_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 4
  _type | type= | offset=16
  _sourceItem | type= | offset=32
  _targetItem | type= | offset=288
  _transitionUri | type= | offset=544
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV44PlaylistArtwork_EditPlaylistCoverArtPageImpl24EditPlaylistCoverArtPageP33_05B278CEAE32A5D391E963D4B68F7CB821TransitioningDelegate =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER NSObject
IVARS 1
  sourceViewIdentifier | type= | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 1
  UIViewControllerTransitioningDelegate
DIRECT_INSTANCE_METHODS 5
  animationControllerForPresentedController:presentingController:sourceController: | types=@40@0:8@16@24@32
  animationControllerForDismissedController: | types=@24@0:8@16
  presentationControllerForPresentedViewController:presentingViewController:sourceViewController: | types=@40@0:8@16@24@32
  init | types=@16@0:8
  .cxx_destruct | types=v16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _TtCV58SwiftEsperanto_audio_player_esperanto_swift_endpoint_proto52Spotify_PlaybackEsperanto_Proto_PlaybackInfoResponseP33_32E4E7B1BF33D30C777AAF5F046519A513_StorageClass =====
IMAGE /private/var/containers/Bundle/Application/C07BB905-A344-4BA1-8CB6-12F42A25A583/Spotify.app/Spotify
SUPER _TtCs12_SwiftObject
IVARS 19
  _status | type= | offset=16
  _lengthMs | type= | offset=32
  _playing | type= | offset=40
  _buffering | type= | offset=41
  _error | type= | offset=44
  _fileID | type= | offset=48
  _fileType | type= | offset=64
  _resolvedContentURL | type= | offset=80
  _fileBitrate | type= | offset=96
  _codecName | type= | offset=104
  _playbackSpeed | type= | offset=120
  _gainAdjustment | type= | offset=128
  _hasLoudness_p | type= | offset=132
  _loudness | type= | offset=136
  _strategy | type= | offset=144
  _targetBitrate | type= | offset=160
  _advisedBitrate | type= | offset=164
  _targetFileAvailable | type= | offset=168
  _audioID | type= | offset=176
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseGSqPSo22SPTBottomBarTransition__Os5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseGSqV30PlaybackControl_SleepTimerImpl14SleepTimerData_Os5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseV27NowPlaying_PublishersKitAPI21PlaybackControlsStateOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseV63SwiftEsperanto_playback_settings_esperanto_swift_messages_proto53Spotify_PlaybackSettings_Esperanto_Proto_ShuffleStateOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseV63SwiftEsperanto_playback_settings_esperanto_swift_messages_proto60Spotify_PlaybackSettings_Esperanto_Proto_GetSettingsResponseOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine11ConduitBaseVC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerP10$10dae18a419QueueSleepTimerDataOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine14FilterProducerGCOS_11Subscribers4Sink_GSqV30PlaybackControl_SleepTimerImpl14SleepTimerData_Os5Never_GSqS4__GSqS4__S5_FTGSqS4__GSqS4___Sb_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 4
  filter | type= | offset=16
  downstream | type= | offset=32
  lock | type= | offset=40
  state | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine14FilterProducerGCOS_11Subscribers4Sink_TGSqV22NowPlaying_ElementsKit13PlaybackState_GSqOS3_23PlayButtonAnimationType__Os5Never_TGSqS4__GSqS5___TGSqS4__GSqS5___S6_FTTGSqS4__GSqS5___TGSqS4__GSqS5____Sb_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 4
  filter | type= | offset=16
  downstream | type= | offset=32
  lock | type= | offset=40
  state | type= | offset=48
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine14FilterProducerGVCS_P10$193b126b821AbstractCombineLatest4SideTVC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerP10$10dae18a419QueueSleepTimerDataGSqPSo26SPTConnectAggregatorEntity___Os5NeverGCOS_11Subscribers4Sink_TS5_GSqPS6____S7___S5__S5_S5_S7_FTS5_S5__Sb_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 4
  filter | type= | offset=16
  downstream | type= | offset=32
  lock | type= | offset=48
  state | type= | offset=56
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseGSqPSo22SPTBottomBarTransition__Os5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseGSqV22NowPlaying_ElementsKit13PlaybackState_Os5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseGSqV43EntitySegments_DynamicTimestampProviderImpl12PlaybackInfo_Os5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseO34MusicPlaybackSpeed_SpeedControlAPI15SpeedBadgeStateOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseO37PlaybackControl_AudioVideoSwitcherAPI23VideoAgeAssuranceResultOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseV27NowPlaying_PublishersKitAPI21PlaybackControlsStateOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseV30MultiPlayer_PageBoundPlayerAPI31PageBoundPlayerReportingContextOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7Combine16PublisherBoxBaseV63SwiftEsperanto_playback_settings_esperanto_swift_messages_proto60Spotify_PlaybackSettings_Esperanto_Proto_StreamSettingChangeOs5Never_ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7CombineP10$193b126b821AbstractCombineLatestTGSqV22NowPlaying_ElementsKit13PlaybackState_GSqOS1_23PlayButtonAnimationType__Os5NeverGCGVOS_10Publishers16RemoveDuplicates_GVS5_13CombineLatest_GVS_12AnyPublisherGSqS2__S4__GS8_GSqS3__S4____P10$193b11a385Inner_GS7__GS8_GSqS2__S4__GS8_GSqS3__S4____GCOS_11Subscribers4Sink_TGSqS2__GSqS3___S4____ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 13
  downstream | type= | offset=16
  buffers | type= | offset=24
  subscriptions | type= | offset=32
  demand | type= | offset=40
  recursion | type= | offset=48
  finished | type= | offset=49
  cancelled | type= | offset=50
  upstreamCount | type= | offset=56
  finishCount | type= | offset=64
  lock | type= | offset=72
  downstreamLock | type= | offset=80
  established | type= | offset=88
  pendingCompletion | type= | offset=89
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGC7CombineP10$193b126b821AbstractCombineLatestTVC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerP10$10dae18a419QueueSleepTimerDataGSqPSo26SPTConnectAggregatorEntity___Os5NeverGCOS_11Subscribers4Sink_TS3_GSqPS4____S5___ =====
IMAGE /System/Library/Frameworks/Combine.framework/Combine
SUPER _TtCs12_SwiftObject
IVARS 13
  downstream | type= | offset=16
  buffers | type= | offset=24
  subscriptions | type= | offset=32
  demand | type= | offset=40
  recursion | type= | offset=48
  finished | type= | offset=49
  cancelled | type= | offset=50
  upstreamCount | type= | offset=56
  finishCount | type= | offset=64
  lock | type= | offset=72
  downstreamLock | type= | offset=80
  established | type= | offset=88
  pendingCompletion | type= | offset=89
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImpl_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER Swift._AnyKeyPath
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImpl_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER Swift._AnyKeyPath
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER Swift._AnyKeyPath
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGSqCSo14SPTPlayerState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGSqCSo14SPTPlayerState__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGV7Combine9PublishedGSqCSo14SPTPlayerState___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGV7Combine9PublishedGSqCSo14SPTPlayerState___$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGSqPSo26SPTConnectAggregatorEntity___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGSqPSo26SPTConnectAggregatorEntity___$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqCSo14SPTPlayerState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqCSo14SPTPlayerState__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqPSo26SPTConnectAggregatorEntity___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqPSo26SPTConnectAggregatorEntity___$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqVS0_14SleepTimerData__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqVS0_14SleepTimerData__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqCSo14SPTPlayerState___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqCSo14SPTPlayerState___$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqVS0_14SleepTimerData___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqVS0_14SleepTimerData___$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs15WritableKeyPathC5UIKitP10$18a43633825NavigationBarPlatterModelGSqCCS0_32NavigationBarTransitionContainer16InteractingModel__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs7KeyPathC5UIKitP10$18a43633825NavigationBarPlatterModelGSqCCS0_32NavigationBarTransitionContainer16InteractingModel__$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptable_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptableV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC28NowPlaying_PublishersKitImpl26StatefulPublisherAdaptable_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationGV7Combine9PublishedV27NowPlaying_PublishersKitAPI21PlaybackControlsState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementation_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementationV27NowPlaying_PublishersKitAPI21PlaybackControlsState_$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC28NowPlaying_PublishersKitImpl37StatefulPlayerPublisherImplementation_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGSqCSo14SPTPlayerState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImpl_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImplGV7Combine9PublishedGSqCSo14SPTPlayerState___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl27PlayerPublisherProviderImpl_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGSqPSo26SPTConnectAggregatorEntity___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImpl_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImplGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28ConnectPublisherProviderImpl_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqCSo14SPTPlayerState__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqPSo26SPTConnectAggregatorEntity___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGSqVS0_14SleepTimerData__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqCSo14SPTPlayerState___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqPSo26SPTConnectAggregatorEntity____$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityControllerGV7Combine9PublishedGSqVS0_14SleepTimerData___$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC30PlaybackControl_SleepTimerImpl28SleepTimerUbiquityController_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _TtGCs7KeyPathC5UIKitP10$18a43633825NavigationBarPlatterModelGSqCCS0_32NavigationBarTransitionContainer16InteractingModel__$ =====
IMAGE /usr/lib/swift/libswiftCore.dylib
SUPER _TtGCs14PartialKeyPathC5UIKitP10$18a43633825NavigationBarPlatterModel_$
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _UIAlertControllerAnimatedTransitioning =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 3
  _presentation | type=B | offset=8
  _alertController | type=@"UIAlertController" | offset=16
  _interactionProgress | type=@"UIInteractionProgress" | offset=24
PROPERTIES 7
  presentation | TB,GisPresentation,V_presentation
  alertController | T@"UIAlertController",&,N,V_alertController
  interactionProgress | T@"UIInteractionProgress",&,N,V_interactionProgress
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 12
  animateTransition: | types=v24@0:8@16
  transitionDuration: | types=d24@0:8@16
  setPresentation: | types=v20@0:8B16
  interactionProgress | types=@16@0:8
  _alertControllerForContext: | types=@24@0:8@16
  .cxx_destruct | types=v16@0:8
  setAlertController: | types=v24@0:8@16
  _animateTransition:completionBlock: | types=v32@0:8@16@?24
  initWithInteractionProgress: | types=@24@0:8@16
  setInteractionProgress: | types=v24@0:8@16
  isPresentation | types=B16@0:8
  alertController | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _UIAlertControllerTransitioningDelegate =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 1
  interactionProgressForPresentation | type=@"UIInteractionProgress" | offset=8
PROPERTIES 5
  interactionProgressForPresentation | T@"UIInteractionProgress",&,N,VinteractionProgressForPresentation
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  UIForceTransitioningDelegate
DIRECT_INSTANCE_METHODS 8
  interactionControllerForPresentation: | types=@24@0:8@16
  setInteractionProgressForPresentation: | types=v24@0:8@16
  animationControllerForPresentedController:presentingController:sourceController: | types=@40@0:8@16@24@32
  _interactionControllerForTransitionOfType:forAlertController: | types=@32@0:8q16@24
  .cxx_destruct | types=v16@0:8
  _isSolariumActionSheet: | types=B24@0:8@16
  interactionProgressForPresentation | types=@16@0:8
  animationControllerForDismissedController: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _UIAnimatedImageTransitionButtonConfigurationVisualProvider =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER UIButtonConfigurationVisualProvider
IVARS 4
  _inViewHierarchy | type=B | offset=320
  _fromConfiguration | type=@"<_UIButtonConfigurationShim>" | offset=328
  _contentAnimationContainerView | type=@"UIView" | offset=336
  _imageViewsByConfiguration | type=@"NSMutableDictionary" | offset=344
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 6
  effectiveContentView | types=@16@0:8
  imageEffectContainerView | types=@16@0:8
  willMoveToWindow: | types=v24@0:8@16
  .cxx_destruct | types=v16@0:8
  _updateImageViewWithConfiguration: | types=B24@0:8@16
  _transitioningImageViewForConfiguration: | types=@24@0:8@16
DIRECT_CLASS_METHODS 0

===== CLASS _UICollectionViewControllerLayoutToLayoutTransition =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 5
  _crossFadeNavigationBar | type=B | offset=8
  _crossFadeBottomBars | type=B | offset=9
  _toLayout | type=@"UICollectionViewLayout" | offset=16
  _interactionController | type=@"UIPercentDrivenInteractiveTransition" | offset=24
  _operation | type=q | offset=32
PROPERTIES 9
  toLayout | T@"UICollectionViewLayout",&,N,V_toLayout
  crossFadeNavigationBar | TB,N,V_crossFadeNavigationBar
  crossFadeBottomBars | TB,N,V_crossFadeBottomBars
  interactionController | T@"UIPercentDrivenInteractiveTransition",N,V_interactionController
  operation | Tq,N,V_operation
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  UIViewControllerAnimatedTransitioning
DIRECT_INSTANCE_METHODS 16
  animateTransition: | types=v24@0:8@16
  operation | types=q16@0:8
  transitionDuration: | types=d24@0:8@16
  animationEnded: | types=v20@0:8B16
  .cxx_destruct | types=v16@0:8
  setOperation: | types=v24@0:8q16
  setToLayout: | types=v24@0:8@16
  toLayout | types=@16@0:8
  _shouldCrossFadeNavigationBar | types=B16@0:8
  _shouldCrossFadeBottomBars | types=B16@0:8
  setInteractionController: | types=v24@0:8@16
  interactionController | types=@16@0:8
  crossFadeBottomBars | types=B16@0:8
  crossFadeNavigationBar | types=B16@0:8
  setCrossFadeBottomBars: | types=v20@0:8B16
  setCrossFadeNavigationBar: | types=v20@0:8B16
DIRECT_CLASS_METHODS 1
  transitionForOperation:fromViewController:toViewController: | types=@40@0:8q16@24@32

===== CLASS _UIContextMenuPlatterTransitionView =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER UIView
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 0

===== CLASS _UICrossSceneMorphAnimationAutomaticTransitionConfiguration =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 2
  morphContainerUIView | type= | offset=8
  destinationUIView | type= | offset=16
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  .cxx_destruct | types=v16@0:8
  init | types=@16@0:8
  initWithTransitionToUIView:inUIView: | types=@32@0:8@16@24
DIRECT_CLASS_METHODS 0

===== CLASS _UIFluidNavigationTransitionsDomain =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER PTDomain
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 0
DIRECT_CLASS_METHODS 5
  parallaxSettings | types=@16@0:8
  domainName | types=@16@0:8
  domainGroupName | types=@16@0:8
  rootSettings | types=@16@0:8
  rootSettingsClass | types=#16@0:8

===== CLASS _UIImageSymbolReplaceTransition =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UIImageSymbolTransition
IVARS 2
  _byLayer | type=B | offset=16
  _style | type=q | offset=24
PROPERTIES 2
  style | Tq,N,V_style
  byLayer | TB,N,V_byLayer
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 11
  setStyle: | types=v24@0:8q16
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  isEqual: | types=B24@0:8@16
  style | types=q16@0:8
  encodeWithCoder: | types=v24@0:8@16
  initWithCoder: | types=@24@0:8@16
  byLayer | types=B16@0:8
  _isValidAnimationPreset | types=B16@0:8
  _nsSymbolContentTransitionRepresentation | types=@16@0:8
  setByLayer: | types=v20@0:8B16
DIRECT_CLASS_METHODS 2
  supportsSecureCoding | types=B16@0:8
  transition | types=@16@0:8

===== CLASS _UIImageSymbolTransition =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 1
  _completionHandler | type=@? | offset=8
PROPERTIES 2
  _validAnimationPreset | TB,R,N,G_isValidAnimationPreset
  completionHandler | T@?,C,N,V_completionHandler
DIRECT_PROTOCOLS 3
  _UIImageSymbolAnimationPreset
  NSCopying
  NSSecureCoding
DIRECT_INSTANCE_METHODS 14
  hash | types=Q16@0:8
  copyWithZone: | types=@24@0:8^{_NSZone=}16
  completionHandler | types=@?16@0:8
  setCompletionHandler: | types=v24@0:8@?16
  .cxx_destruct | types=v16@0:8
  isEqual: | types=B24@0:8@16
  init | types=@16@0:8
  encodeWithCoder: | types=v24@0:8@16
  initWithCoder: | types=@24@0:8@16
  _isSymbolEffect | types=B16@0:8
  _isSymbolTransition | types=B16@0:8
  _isValidAnimationPreset | types=B16@0:8
  _nsSymbolContentTransitionRepresentation | types=@16@0:8
  _performCompletionHandler | types=v16@0:8
DIRECT_CLASS_METHODS 2
  supportsSecureCoding | types=B16@0:8
  transition | types=@16@0:8

===== CLASS _UIImageViewPendingSymbolContentTransition =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 7
  _pendingLayoutPass | type=B | offset=8
  _symbolContentTransition | type=@"NSSymbolContentTransition" | offset=16
  _options | type=@"NSSymbolEffectOptions" | offset=24
  _completionHandler | type=@? | offset=32
  _sourceSymbolImage | type=@"UIImage" | offset=40
  _targetSymbolImage | type=@"UIImage" | offset=48
  _initialSymbolAbsoluteRect | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=56
PROPERTIES 7
  symbolContentTransition | T@"NSSymbolContentTransition",R,N,V_symbolContentTransition
  options | T@"NSSymbolEffectOptions",R,N,V_options
  completionHandler | T@?,R,N,V_completionHandler
  sourceSymbolImage | T@"UIImage",R,N,V_sourceSymbolImage
  targetSymbolImage | T@"UIImage",R,N,V_targetSymbolImage
  pendingLayoutPass | TB,N,GisPendingLayoutPass,V_pendingLayoutPass
  initialSymbolAbsoluteRect | T{CGRect={CGPoint=dd}{CGSize=dd}},N,V_initialSymbolAbsoluteRect
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 11
  completionHandler | types=@?16@0:8
  .cxx_destruct | types=v16@0:8
  init | types=@16@0:8
  options | types=@16@0:8
  initialSymbolAbsoluteRect | types={CGRect={CGPoint=dd}{CGSize=dd}}16@0:8
  isPendingLayoutPass | types=B16@0:8
  setInitialSymbolAbsoluteRect: | types=v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
  setPendingLayoutPass: | types=v20@0:8B16
  sourceSymbolImage | types=@16@0:8
  symbolContentTransition | types=@16@0:8
  targetSymbolImage | types=@16@0:8
DIRECT_CLASS_METHODS 1
  transitionWithTransition:sourceSymbolImage:targetSymbolImage:options:completion: | types=@56@0:8@16@24@32@40@?48

===== CLASS _UILegacyModalViewControllerTransition =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER UIViewControllerTransition
IVARS 1
  _modalTransitionStyle | type=q | offset=8
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 3
  _hasOwnInteractiveExitGestureForTraits: | types=B24@0:8@16
  _isSupportedGivenTraits: | types=B24@0:8@16
  _wasAssignedToViewController: | types=v24@0:8@16
DIRECT_CLASS_METHODS 1
  transitionWithStyle: | types=@24@0:8q16

===== CLASS _UINavigationBarTransitionAssistant =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 13
  _animationCount | type=q | offset=8
  _animationIDs | type=@"NSMutableArray" | offset=16
  _interruptable | type=B | offset=24
  _interactive | type=B | offset=25
  _needsLifetimeExtended | type=B | offset=26
  _cancelledTransition | type=B | offset=27
  _shouldHideBackButtonDuringTransition | type=B | offset=28
  _shouldUpdatePromptAfterTransition | type=B | offset=29
  _transitionCoordinator | type=@"<UIViewControllerTransitionCoordinator>" | offset=32
  _navigationBar | type=@"UINavigationBar" | offset=40
  _delegate | type=@"<_UINavigationBarDelegatePrivate>" | offset=48
  _transition | type=q | offset=56
  _duration | type=d | offset=64
PROPERTIES 14
  transitionCoordinator | T@"<UIViewControllerTransitionCoordinator>",R,W,N,V_transitionCoordinator
  navigationBar | T@"UINavigationBar",R,W,N,V_navigationBar
  delegate | T@"<_UINavigationBarDelegatePrivate>",R,W,N,V_delegate
  transition | Tq,R,N,V_transition
  duration | Td,R,N,V_duration
  interruptable | TB,R,N,V_interruptable
  interactive | TB,R,N,V_interactive
  needsLifetimeExtended | TB,N,V_needsLifetimeExtended
  shouldAnimateAlongside | TB,R,N
  shouldCrossfade | TB,R,N
  cancelledTransition | TB,R,N,V_cancelledTransition
  shouldHideBackButtonDuringTransition | TB,N,V_shouldHideBackButtonDuringTransition
  shouldUpdatePromptAfterTransition | TB,N,V_shouldUpdatePromptAfterTransition
  animationIDs | T@"NSArray",R,N,V_animationIDs
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 34
  shouldCrossfade | types=B16@0:8
  transitionCoordinator | types=@16@0:8
  shouldUpdatePromptAfterTransition | types=B16@0:8
  interactive | types=B16@0:8
  shouldAnimateAlongside | types=B16@0:8
  navigationBar | types=@16@0:8
  _getInteractive | types=v16@0:8
  _clearAnimationsWithDuration:curve:reverse: | types=v36@0:8d16q24B32
  initWithNavigationBar:delegate: | types=@32@0:8@16@24
  _startTrackingAnimations | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  finishTrackingInteractiveTransition | types=v16@0:8
  updateInteractiveTransitionPercent: | types=v24@0:8d16
  _getPopDurationAndTransitionAlwaysCrossfade: | types=v20@0:8B16
  shouldHideBackButtonDuringTransition | types=B16@0:8
  transition | types=q16@0:8
  needsLifetimeExtended | types=B16@0:8
  finishInteractiveTransitionPercent:completionSpeed:completionCurve: | types=v40@0:8d16d24q32
  cancelledTransition | types=B16@0:8
  cancelInteractiveTransitionPercent:completionSpeed:completionCurve: | types=v40@0:8d16d24q32
  delegate | types=@16@0:8
  setShouldUpdatePromptAfterTransition: | types=v20@0:8B16
  decrementAnimationCount | types=v16@0:8
  setShouldHideBackButtonDuringTransition: | types=v20@0:8B16
  setNeedsLifetimeExtended: | types=v20@0:8B16
  _finishTrackingAnimations | types=v16@0:8
  startInteractiveTransition | types=v16@0:8
  duration | types=d16@0:8
  interruptable | types=B16@0:8
  incrementAnimationCount | types=v16@0:8
  _transitionOverrideFrom:defaultingTo: | types=q32@0:8@16q24
  animationIDs | types=@16@0:8
  _getPushDurationAndTransitionAlwaysCrossfade: | types=v20@0:8B16
  _getTransitionCoordinator | types=v16@0:8
DIRECT_CLASS_METHODS 2
  popTransitionAssistantForNavigationBar:delegate:crossfade: | types=@36@0:8@16@24B32
  pushTransitionAssistantForNavigationBar:delegate:crossfade: | types=@36@0:8@16@24B32

===== CLASS _UINavigationBarTransitionContext =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER NSObject
IVARS 23
  _navigationBar | type=@"UINavigationBar" | offset=8
  _stack | type=@"_UINavigationBarItemStack" | offset=16
  _promptView | type=@"_UINavigationBarModernPromptView" | offset=24
  _contentView | type=@"_UINavigationBarContentView" | offset=32
  _backgroundView | type=@"_UIBarBackground" | offset=40
  _largeTitleView | type=@"_UINavigationBarLargeTitleView" | offset=48
  _tabBarHostedView | type=@"UIView" | offset=56
  _transitionOverlayView | type=@"UIView" | offset=64
  _fromLayout | type=@"_UINavigationBarLayout" | offset=72
  _toLayout | type=@"_UINavigationBarLayout" | offset=80
  _fromContentLayout | type=@"_UINavigationBarContentViewLayout" | offset=88
  _toContentLayout | type=@"_UINavigationBarContentViewLayout" | offset=96
  _fromLargeTitleLayout | type=@"_UINavigationBarLargeTitleViewLayout" | offset=104
  _toLargeTitleLayout | type=@"_UINavigationBarLargeTitleViewLayout" | offset=112
  _backgroundAlpha | type=d | offset=120
  _twoPartAnimationBaseDuration | type=d | offset=128
  _twoPartAnimationOverlapDuration | type=d | offset=136
  _largeTitleTransitionType | type=q | offset=144
  _apiVersion | type=q | offset=152
  _flags | type={?="isPushOperation"b1"isRTL"b1"compact"b1"allowLargeTitles"b1"twoPart"b1"beginWithLargeTitle"b1"endWithLargeTitle"b1"observedScrollViewOffsetIsApplicable"b1"sharesContentViewLayouts"b1"beginWithTransparencyAllowed"b1"endWithTransparencyAllowed"b1"usesBarBackground"b1} | offset=160
  _clippingViews | type=@"NSMutableSet" | offset=168
  _completionHandler | type=@? | offset=176
  _startingContentOffsetForObservedScrollView | type={CGPoint="x"d"y"d} | offset=184
PROPERTIES 34
  transition | Tq,R,D,N
  completionHandler | T@?,C,N,V_completionHandler
  navigationBar | T@"UINavigationBar",N,V_navigationBar
  stack | T@"_UINavigationBarItemStack",&,N,V_stack
  isRTL | TB,N,SsetRTL:
  isPushOperation | TB,N,SsetPushOperation:
  compact | TB,N
  allowLargeTitles | TB,N
  twoPart | TB,N
  apiVersion | Tq,N,V_apiVersion
  backgroundAlpha | Td,N,V_backgroundAlpha
  promptView | T@"_UINavigationBarModernPromptView",&,N,V_promptView
  contentView | T@"_UINavigationBarContentView",&,N,V_contentView
  backgroundView | T@"_UIBarBackground",R,N,V_backgroundView
  largeTitleView | T@"_UINavigationBarLargeTitleView",&,N,V_largeTitleView
  tabBarHostedView | T@"UIView",&,N,V_tabBarHostedView
  viewFadingInFromCustomAlpha | T@"UIView",R,N
  viewUsingEaseInCurve | T@"UIView",R,N
  beginWithLargeTitle | TB,N
  endWithLargeTitle | TB,N
  beginWithTransparencyAllowed | TB,N
  endWithTransparencyAllowed | TB,N
  startingContentOffsetForObservedScrollView | T{CGPoint=dd},N,V_startingContentOffsetForObservedScrollView
  observedScrollViewOffsetIsApplicable | TB,N
  sharesContentViewLayouts | TB,N
  fromLayout | T@"_UINavigationBarLayout",&,N,V_fromLayout
  toLayout | T@"_UINavigationBarLayout",&,N,V_toLayout
  transitionOverlayView | T@"UIView",&,N,V_transitionOverlayView
  fromLargeTitleViewLayout | T@"_UINavigationBarLargeTitleViewLayout",&,N
  toLargeTitleViewLayout | T@"_UINavigationBarLargeTitleViewLayout",&,N
  hash | TQ,R
  superclass | T#,R
  description | T@"NSString",R,C
  debugDescription | T@"NSString",?,R,C
DIRECT_PROTOCOLS 1
  _UINavigationBarTransitionContextProtocol
DIRECT_INSTANCE_METHODS 78
  fromLayout | types=@16@0:8
  setStack: | types=v24@0:8@16
  setTabBarHostedView: | types=v24@0:8@16
  tabBarHostedView | types=@16@0:8
  isRTL | types=B16@0:8
  backgroundAlpha | types=d16@0:8
  setBackgroundAlpha: | types=v24@0:8d16
  stack | types=@16@0:8
  complete | types=v16@0:8
  navigationBar | types=@16@0:8
  completionHandler | types=@?16@0:8
  setCompletionHandler: | types=v24@0:8@?16
  setPromptView: | types=v24@0:8@16
  animate | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  contentView | types=@16@0:8
  promptView | types=@16@0:8
  backgroundView | types=@16@0:8
  setLargeTitleView: | types=v24@0:8@16
  setContentView: | types=v24@0:8@16
  compact | types=B16@0:8
  cancel | types=v16@0:8
  setFromLayout: | types=v24@0:8@16
  setToLayout: | types=v24@0:8@16
  prepare | types=v16@0:8
  setCompact: | types=v20@0:8B16
  setNavigationBar: | types=v24@0:8@16
  toLayout | types=@16@0:8
  _animationOptions | types=Q16@0:8
  largeTitleView | types=@16@0:8
  setRTL: | types=v20@0:8B16
  description | types=@16@0:8
  twoPart | types=B16@0:8
  isPushOperation | types=B16@0:8
  _animateAsTwoPartsWithOverlap:partOne:partTwo: | types=v40@0:8d16@?24@?32
  _animateAsTwoPartsWithOverlapIfNecessaryPartOne:partTwo: | types=v32@0:8@?16@?24
  _animateAsTwoPartsWithoutOverlap:partTwo: | types=v32@0:8@?16@?24
  _animateBackgroundView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _animateInProcessAsTwoPartsWithKeyframeID:overlap:partOne:partTwo: | types=v48@0:8@16d24@?32@?40
  _animateInProcessAsTwoPartsWithOverlapIfNecessaryWithKeyframeID:fractionComplete:partOne:partTwo: | types=v48@0:8@16d24@?32@?40
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
  _resetContentAndLargeTitleViewCompleted: | types=v20@0:8B16
  _updateIncomingLayoutWidthToMatchOutgoingLayout | types=v16@0:8
  allowLargeTitles | types=B16@0:8
  apiVersion | types=q16@0:8
  beginWithLargeTitle | types=B16@0:8
  beginWithTransparencyAllowed | types=B16@0:8
  endWithLargeTitle | types=B16@0:8
  endWithTransparencyAllowed | types=B16@0:8
  fromLargeTitleViewLayout | types=@16@0:8
  observedScrollViewOffsetIsApplicable | types=B16@0:8
  prepareForInterruption | types=@?16@0:8
  recordUpdates: | types=v24@0:8@?16
  setAllLargeTitleLayoutsVisible | types=v16@0:8
  setAllowLargeTitles: | types=v20@0:8B16
  setApiVersion: | types=v24@0:8q16
  setBackgroundView:isBarBackground: | types=v28@0:8@16B24
  setBeginWithLargeTitle: | types=v20@0:8B16
  setBeginWithTransparencyAllowed: | types=v20@0:8B16
  ... 18 methods omitted (limit 60)
DIRECT_CLASS_METHODS 3
  fadeOutFunction | types=@16@0:8
  contextForTransition:withIdiom:completion: | types=@40@0:8q16q24@?32
  fadeInFunction | types=@16@0:8

===== CLASS _UINavigationBarTransitionContextCrossfade =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 0
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 14
  complete | types=v16@0:8
  animate | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _animateContentView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _animateLargeTitleView | types=v16@0:8
  _animateSearchBar | types=v16@0:8
  _finishWithFinalLayout:invalidLayout: | types=v32@0:8@16@24
  _prepareContentView | types=v16@0:8
  _prepareLargeTitleView | types=v16@0:8
  _prepareSearchBar | types=v16@0:8
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
DIRECT_CLASS_METHODS 0

===== CLASS _UINavigationBarTransitionContextDismissSearch =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 2
  _transitioningSearchBar | type=@"UISearchBar" | offset=200
  _transitioningScopeBarContainer | type=@"UIView" | offset=208
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 9
  complete | types=v16@0:8
  animate | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
  _shouldCrossfadeDismissal | types=B16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _UINavigationBarTransitionContextPop =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 6
  _endingNewTitleViewFrame | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=200
  _endingNewBackButtonFrame | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=232
  _titleTransitionDistance | type={CGSize="width"d"height"d} | offset=264
  _titleTransitionDistanceExcludingLargeTitleOffset | type={CGSize="width"d"height"d} | offset=280
  _titleTransitionAdjustment | type=d | offset=296
  _unfreezeTitleControlOnFinish | type=B | offset=304
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 19
  complete | types=v16@0:8
  animate | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _animateBackgroundView | types=v16@0:8
  _animateContentView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _animateLargeTitleView | types=v16@0:8
  _animateScaleTransition | types=v16@0:8
  _animateSearchBar | types=v16@0:8
  _finishWithFinalLayout:invalidLayout: | types=v32@0:8@16@24
  _prepareBackgroundView | types=v16@0:8
  _prepareContentView | types=v16@0:8
  _prepareLargeTitleView | types=v16@0:8
  _prepareScaleTransition | types=v16@0:8
  _prepareSearchBar | types=v16@0:8
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
  viewUsingEaseInCurve | types=@16@0:8
DIRECT_CLASS_METHODS 0

===== CLASS _UINavigationBarTransitionContextPresentSearch =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 1
  _transitioningScopeBarContainer | type=@"UIView" | offset=200
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 11
  complete | types=v16@0:8
  animate | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _animateBackgroundView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _prepareBackgroundView | types=v16@0:8
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
  _resetContentAndLargeTitleViewCompleted: | types=v20@0:8B16
DIRECT_CLASS_METHODS 0

===== CLASS _UINavigationBarTransitionContextPush =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 6
  _endingNewTitleViewFrame | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=200
  _endingNewBackButtonFrame | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=232
  _endingBackIndicatorViewFrame | type={CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} | offset=264
  _titleTransitionDistance | type={CGSize="width"d"height"d} | offset=296
  _titleTransitionDistanceExcludingLargeTitleOffset | type={CGSize="width"d"height"d} | offset=312
  _unfreezeTitleControlOnFinish | type=B | offset=328
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 18
  complete | types=v16@0:8
  animate | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _animateBackgroundView | types=v16@0:8
  _animateContentView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _animateLargeTitleView | types=v16@0:8
  _animateScaleTransition | types=v16@0:8
  _animateSearchBar | types=v16@0:8
  _finishWithFinalLayout:invalidLayout: | types=v32@0:8@16@24
  _prepareBackgroundView | types=v16@0:8
  _prepareContentView | types=v16@0:8
  _prepareLargeTitleView | types=v16@0:8
  _prepareScaleTransition | types=v16@0:8
  _prepareSearchBar | types=v16@0:8
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
DIRECT_CLASS_METHODS 0

===== CLASS _UINavigationBarTransitionContextZoom =====
IMAGE /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore
SUPER _UINavigationBarTransitionContext
IVARS 2
  _temporaryViews | type=@"NSMutableArray" | offset=200
  _isDeferringCleanup | type=B | offset=208
PROPERTIES 0
DIRECT_PROTOCOLS 0
DIRECT_INSTANCE_METHODS 21
  complete | types=v16@0:8
  animate | types=v16@0:8
  .cxx_destruct | types=v16@0:8
  transition | types=q16@0:8
  cancel | types=v16@0:8
  prepare | types=v16@0:8
  _addTemporaryView: | types=v24@0:8@16
  _animateBackgroundView | types=v16@0:8
  _animateContentView | types=v16@0:8
  _animateFromPalette:fromPaletteFrame:toPalette:toPaletteFrame: | types=v96@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56{CGRect={CGPoint=dd}{CGSize=dd}}64
  _animateLargeTitleView | types=v16@0:8
  _animateSearchBar | types=v16@0:8
  _cleanupZoomContent | types=v16@0:8
  _finishWithFinalLayout:invalidLayout: | types=v32@0:8@16@24
  _insertTemporaryBackgroundForLayout: | types=v24@0:8@16
  _prepareContentView | types=v16@0:8
  _prepareLargeTitleView | types=v16@0:8
  _prepareSearchBar | types=v16@0:8
  _prepareTransitionFromPalette:toPalette:toPaletteFrame: | types=v64@0:8@16@24{CGRect={CGPoint=dd}{CGSize=dd}}32
  prepareForInterruption | types=@?16@0:8
  shouldPerformTwoPartCrossfadeTransition | types=B16@0:8
DIRECT_CLASS_METHODS 0

MATCHES OMITTED AFTER CAP: 1319
