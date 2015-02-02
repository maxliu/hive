/**
 * Autogenerated by Thrift Compiler (0.9.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
#ifndef serde_CONSTANTS_H
#define serde_CONSTANTS_H

#include "serde_types.h"

namespace Hive {

class serdeConstants {
 public:
  serdeConstants();

  std::string SERIALIZATION_LIB;
  std::string SERIALIZATION_CLASS;
  std::string SERIALIZATION_FORMAT;
  std::string SERIALIZATION_DDL;
  std::string SERIALIZATION_NULL_FORMAT;
  std::string SERIALIZATION_LAST_COLUMN_TAKES_REST;
  std::string SERIALIZATION_SORT_ORDER;
  std::string SERIALIZATION_USE_JSON_OBJECTS;
  std::string SERIALIZATION_ENCODING;
  std::string FIELD_DELIM;
  std::string COLLECTION_DELIM;
  std::string LINE_DELIM;
  std::string MAPKEY_DELIM;
  std::string QUOTE_CHAR;
  std::string ESCAPE_CHAR;
  std::string HEADER_COUNT;
  std::string FOOTER_COUNT;
  std::string VOID_TYPE_NAME;
  std::string BOOLEAN_TYPE_NAME;
  std::string TINYINT_TYPE_NAME;
  std::string SMALLINT_TYPE_NAME;
  std::string INT_TYPE_NAME;
  std::string BIGINT_TYPE_NAME;
  std::string FLOAT_TYPE_NAME;
  std::string DOUBLE_TYPE_NAME;
  std::string STRING_TYPE_NAME;
  std::string CHAR_TYPE_NAME;
  std::string VARCHAR_TYPE_NAME;
  std::string DATE_TYPE_NAME;
  std::string DATETIME_TYPE_NAME;
  std::string TIMESTAMP_TYPE_NAME;
  std::string DECIMAL_TYPE_NAME;
  std::string BINARY_TYPE_NAME;
  std::string LIST_TYPE_NAME;
  std::string MAP_TYPE_NAME;
  std::string STRUCT_TYPE_NAME;
  std::string UNION_TYPE_NAME;
  std::string LIST_COLUMNS;
  std::string LIST_COLUMN_TYPES;
  std::string TIMESTAMP_FORMATS;
  std::set<std::string>  PrimitiveTypes;
  std::set<std::string>  CollectionTypes;
  std::set<std::string>  IntegralTypes;
};

extern const serdeConstants g_serde_constants;

} // namespace

#endif
