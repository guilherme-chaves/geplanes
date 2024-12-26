import { Buffer } from "node:buffer";
import { customType, pgSchema } from "drizzle-orm/pg-core";

export const bytea = customType<
  { data: Buffer; notNull: false; default: false }
>({
  dataType() {
    return "bytea";
  },
});

export const schema = pgSchema("geplanes");

export const fileContentType = schema.enum("file_content_type", [
  "application/pdf", // .pdf
  "application/zip", // .zip
  "application/vnd.rar", // .rar
  "application/vnd.ms-excel", // .xls .xlsx
  "application/vnd.ms-powerpoint", // .ppt .pptx
  "application/msword", // .doc .docx
  "image/jpeg", // .jpg .jpeg
  "image/png", // .png
  "image/bmp", // .bmp
  "image/webp", // .webp
  "image/heic", // .heic
  "text/csv", // .csv
  "text/richtext", // .rtf
  "text/plain", // .txt
  "audio/mpeg", // .mp3
  "audio/mp4", // .mp4
  "audio/vorbis", // .ogg
  "audio/opus",
  "audio/ogg",
]);

export const permissonType = schema.enum("permission_type", [
  "ACCESS",
  "SEARCH",
  "EDIT",
  "NONE",
]);
