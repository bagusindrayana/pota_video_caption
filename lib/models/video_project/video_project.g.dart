// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_project.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoProjectCollection on Isar {
  IsarCollection<VideoProject> get videoProjects => this.collection();
}

const VideoProjectSchema = CollectionSchema(
  name: r'VideoProject',
  id: 7545039586988211521,
  properties: {
    r'captions': PropertySchema(
      id: 0,
      name: r'captions',
      type: IsarType.objectList,
      target: r'Caption',
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'duration': PropertySchema(
      id: 2,
      name: r'duration',
      type: IsarType.long,
    ),
    r'exported': PropertySchema(
      id: 3,
      name: r'exported',
      type: IsarType.bool,
    ),
    r'originalPath': PropertySchema(
      id: 4,
      name: r'originalPath',
      type: IsarType.string,
    ),
    r'thumbnail': PropertySchema(
      id: 5,
      name: r'thumbnail',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'videoPath': PropertySchema(
      id: 7,
      name: r'videoPath',
      type: IsarType.string,
    )
  },
  estimateSize: _videoProjectEstimateSize,
  serialize: _videoProjectSerialize,
  deserialize: _videoProjectDeserialize,
  deserializeProp: _videoProjectDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Caption': CaptionSchema},
  getId: _videoProjectGetId,
  getLinks: _videoProjectGetLinks,
  attach: _videoProjectAttach,
  version: '3.1.0+1',
);

int _videoProjectEstimateSize(
  VideoProject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.captions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Caption]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += CaptionSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.originalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.thumbnail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.videoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _videoProjectSerialize(
  VideoProject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Caption>(
    offsets[0],
    allOffsets,
    CaptionSchema.serialize,
    object.captions,
  );
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.duration);
  writer.writeBool(offsets[3], object.exported);
  writer.writeString(offsets[4], object.originalPath);
  writer.writeString(offsets[5], object.thumbnail);
  writer.writeString(offsets[6], object.title);
  writer.writeString(offsets[7], object.videoPath);
}

VideoProject _videoProjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoProject(
    captions: reader.readObjectList<Caption>(
      offsets[0],
      CaptionSchema.deserialize,
      allOffsets,
      Caption(),
    ),
    createdAt: reader.readDateTimeOrNull(offsets[1]),
    duration: reader.readLongOrNull(offsets[2]),
    exported: reader.readBoolOrNull(offsets[3]),
    originalPath: reader.readStringOrNull(offsets[4]),
    thumbnail: reader.readStringOrNull(offsets[5]),
    title: reader.readStringOrNull(offsets[6]),
    videoPath: reader.readStringOrNull(offsets[7]),
  );
  object.id = id;
  return object;
}

P _videoProjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Caption>(
        offset,
        CaptionSchema.deserialize,
        allOffsets,
        Caption(),
      )) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoProjectGetId(VideoProject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoProjectGetLinks(VideoProject object) {
  return [];
}

void _videoProjectAttach(
    IsarCollection<dynamic> col, Id id, VideoProject object) {
  object.id = id;
}

extension VideoProjectQueryWhereSort
    on QueryBuilder<VideoProject, VideoProject, QWhere> {
  QueryBuilder<VideoProject, VideoProject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhere> anyTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'title'),
      );
    });
  }
}

extension VideoProjectQueryWhere
    on QueryBuilder<VideoProject, VideoProject, QWhereClause> {
  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [null],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleEqualTo(
      String? title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleNotEqualTo(
      String? title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleGreaterThan(
    String? title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [title],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleLessThan(
    String? title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [],
        upper: [title],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleBetween(
    String? lowerTitle,
    String? upperTitle, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [lowerTitle],
        includeLower: includeLower,
        upper: [upperTitle],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleStartsWith(
      String TitlePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [TitlePrefix],
        upper: ['$TitlePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [''],
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterWhereClause>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ));
      }
    });
  }
}

extension VideoProjectQueryFilter
    on QueryBuilder<VideoProject, VideoProject, QFilterCondition> {
  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'captions',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'captions',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'captions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      durationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      exportedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exported',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      exportedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exported',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      exportedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exported',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalPath',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalPath',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      originalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      thumbnailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videoPath',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videoPath',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoPath',
        value: '',
      ));
    });
  }
}

extension VideoProjectQueryObject
    on QueryBuilder<VideoProject, VideoProject, QFilterCondition> {
  QueryBuilder<VideoProject, VideoProject, QAfterFilterCondition>
      captionsElement(FilterQuery<Caption> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'captions');
    });
  }
}

extension VideoProjectQueryLinks
    on QueryBuilder<VideoProject, VideoProject, QFilterCondition> {}

extension VideoProjectQuerySortBy
    on QueryBuilder<VideoProject, VideoProject, QSortBy> {
  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByExported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exported', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByExportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exported', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy>
      sortByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnail', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnail', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> sortByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoProjectQuerySortThenBy
    on QueryBuilder<VideoProject, VideoProject, QSortThenBy> {
  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByExported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exported', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByExportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exported', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy>
      thenByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnail', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnail', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QAfterSortBy> thenByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoProjectQueryWhereDistinct
    on QueryBuilder<VideoProject, VideoProject, QDistinct> {
  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByExported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exported');
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByOriginalPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByThumbnail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoProject, VideoProject, QDistinct> distinctByVideoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoPath', caseSensitive: caseSensitive);
    });
  }
}

extension VideoProjectQueryProperty
    on QueryBuilder<VideoProject, VideoProject, QQueryProperty> {
  QueryBuilder<VideoProject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoProject, List<Caption>?, QQueryOperations>
      captionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'captions');
    });
  }

  QueryBuilder<VideoProject, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<VideoProject, int?, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<VideoProject, bool?, QQueryOperations> exportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exported');
    });
  }

  QueryBuilder<VideoProject, String?, QQueryOperations> originalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPath');
    });
  }

  QueryBuilder<VideoProject, String?, QQueryOperations> thumbnailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnail');
    });
  }

  QueryBuilder<VideoProject, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<VideoProject, String?, QQueryOperations> videoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoPath');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CaptionSchema = Schema(
  name: r'Caption',
  id: -1802792512215802766,
  properties: {
    r'addBox': PropertySchema(
      id: 0,
      name: r'addBox',
      type: IsarType.bool,
    ),
    r'alpha': PropertySchema(
      id: 1,
      name: r'alpha',
      type: IsarType.double,
    ),
    r'borderColor': PropertySchema(
      id: 2,
      name: r'borderColor',
      type: IsarType.string,
    ),
    r'borderWidth': PropertySchema(
      id: 3,
      name: r'borderWidth',
      type: IsarType.long,
    ),
    r'boxBorderColor': PropertySchema(
      id: 4,
      name: r'boxBorderColor',
      type: IsarType.string,
    ),
    r'boxBorderWidth': PropertySchema(
      id: 5,
      name: r'boxBorderWidth',
      type: IsarType.long,
    ),
    r'boxColor': PropertySchema(
      id: 6,
      name: r'boxColor',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 7,
      name: r'endTime',
      type: IsarType.string,
    ),
    r'fontColor': PropertySchema(
      id: 8,
      name: r'fontColor',
      type: IsarType.string,
    ),
    r'fontFile': PropertySchema(
      id: 9,
      name: r'fontFile',
      type: IsarType.string,
    ),
    r'fontSize': PropertySchema(
      id: 10,
      name: r'fontSize',
      type: IsarType.long,
    ),
    r'lineSpacing': PropertySchema(
      id: 11,
      name: r'lineSpacing',
      type: IsarType.double,
    ),
    r'shadowColor': PropertySchema(
      id: 12,
      name: r'shadowColor',
      type: IsarType.long,
    ),
    r'shadowX': PropertySchema(
      id: 13,
      name: r'shadowX',
      type: IsarType.long,
    ),
    r'shadowY': PropertySchema(
      id: 14,
      name: r'shadowY',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 15,
      name: r'startTime',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 16,
      name: r'text',
      type: IsarType.string,
    ),
    r'textAlign': PropertySchema(
      id: 17,
      name: r'textAlign',
      type: IsarType.string,
    ),
    r'x': PropertySchema(
      id: 18,
      name: r'x',
      type: IsarType.double,
    ),
    r'y': PropertySchema(
      id: 19,
      name: r'y',
      type: IsarType.double,
    )
  },
  estimateSize: _captionEstimateSize,
  serialize: _captionSerialize,
  deserialize: _captionDeserialize,
  deserializeProp: _captionDeserializeProp,
);

int _captionEstimateSize(
  Caption object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.borderColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.boxBorderColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.boxColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.endTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fontColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fontFile;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.textAlign;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _captionSerialize(
  Caption object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.addBox);
  writer.writeDouble(offsets[1], object.alpha);
  writer.writeString(offsets[2], object.borderColor);
  writer.writeLong(offsets[3], object.borderWidth);
  writer.writeString(offsets[4], object.boxBorderColor);
  writer.writeLong(offsets[5], object.boxBorderWidth);
  writer.writeString(offsets[6], object.boxColor);
  writer.writeString(offsets[7], object.endTime);
  writer.writeString(offsets[8], object.fontColor);
  writer.writeString(offsets[9], object.fontFile);
  writer.writeLong(offsets[10], object.fontSize);
  writer.writeDouble(offsets[11], object.lineSpacing);
  writer.writeLong(offsets[12], object.shadowColor);
  writer.writeLong(offsets[13], object.shadowX);
  writer.writeLong(offsets[14], object.shadowY);
  writer.writeString(offsets[15], object.startTime);
  writer.writeString(offsets[16], object.text);
  writer.writeString(offsets[17], object.textAlign);
  writer.writeDouble(offsets[18], object.x);
  writer.writeDouble(offsets[19], object.y);
}

Caption _captionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Caption(
    addBox: reader.readBoolOrNull(offsets[0]),
    alpha: reader.readDoubleOrNull(offsets[1]),
    borderColor: reader.readStringOrNull(offsets[2]),
    borderWidth: reader.readLongOrNull(offsets[3]),
    boxBorderColor: reader.readStringOrNull(offsets[4]),
    boxBorderWidth: reader.readLongOrNull(offsets[5]),
    boxColor: reader.readStringOrNull(offsets[6]),
    endTime: reader.readStringOrNull(offsets[7]),
    fontColor: reader.readStringOrNull(offsets[8]),
    fontFile: reader.readStringOrNull(offsets[9]),
    fontSize: reader.readLongOrNull(offsets[10]),
    lineSpacing: reader.readDoubleOrNull(offsets[11]),
    shadowColor: reader.readLongOrNull(offsets[12]),
    shadowX: reader.readLongOrNull(offsets[13]),
    shadowY: reader.readLongOrNull(offsets[14]),
    startTime: reader.readStringOrNull(offsets[15]),
    text: reader.readStringOrNull(offsets[16]),
    textAlign: reader.readStringOrNull(offsets[17]),
    x: reader.readDoubleOrNull(offsets[18]),
    y: reader.readDoubleOrNull(offsets[19]),
  );
  return object;
}

P _captionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readDoubleOrNull(offset)) as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CaptionQueryFilter
    on QueryBuilder<Caption, Caption, QFilterCondition> {
  QueryBuilder<Caption, Caption, QAfterFilterCondition> addBoxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addBox',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> addBoxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'addBox',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> addBoxEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addBox',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alpha',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alpha',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alpha',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alpha',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alpha',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> alphaBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alpha',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'borderColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'borderColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'borderColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'borderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'borderColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'borderColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      borderColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'borderColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'borderWidth',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'borderWidth',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'borderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'borderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'borderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> borderWidthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'borderWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boxBorderColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boxBorderColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boxBorderColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'boxBorderColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'boxBorderColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boxBorderColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'boxBorderColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderWidthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boxBorderWidth',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderWidthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boxBorderWidth',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderWidthEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boxBorderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition>
      boxBorderWidthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boxBorderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderWidthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boxBorderWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxBorderWidthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boxBorderWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boxColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boxColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boxColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'boxColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'boxColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boxColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> boxColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'boxColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fontColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fontColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fontFile',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fontFile',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontFile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontFile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFile',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontFileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontFile',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fontSize',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fontSize',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> fontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lineSpacing',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lineSpacing',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lineSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lineSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lineSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> lineSpacingBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lineSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shadowColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shadowColor',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shadowColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shadowColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shadowColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowColorBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shadowColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shadowX',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shadowX',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shadowX',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shadowX',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shadowX',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowXBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shadowX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shadowY',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shadowY',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shadowY',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shadowY',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shadowY',
        value: value,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> shadowYBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shadowY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'textAlign',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'textAlign',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textAlign',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textAlign',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> textAlignIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'x',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'x',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> xBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'x',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'y',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'y',
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Caption, Caption, QAfterFilterCondition> yBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'y',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CaptionQueryObject
    on QueryBuilder<Caption, Caption, QFilterCondition> {}
