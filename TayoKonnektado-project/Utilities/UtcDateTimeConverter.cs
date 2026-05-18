using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace TayoKonnektado_project.Utilities
{
    /// <summary>
    /// Ensures DateTime values round-trip as UTC (with 'Z' suffix) in JSON responses.
    /// Without this, EF Core returns DateTime with Kind=Unspecified, causing ASP.NET to
    /// omit the 'Z', which makes JavaScript treat the time as local instead of UTC.
    /// </summary>
    public class UtcDateTimeConverter : JsonConverter<DateTime>
    {
        public override DateTime Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            var dt = reader.GetDateTime();
            return DateTime.SpecifyKind(dt, DateTimeKind.Utc);
        }

        public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
        {
            writer.WriteStringValue(DateTime.SpecifyKind(value, DateTimeKind.Utc));
        }
    }
}
