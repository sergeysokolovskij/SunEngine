using SunEngine.Core.Configuration.ConfigItemType;

namespace SunEngine.Core.SectionsData
{
	public class PostsServerSectionData : ServerSectionData
	{
		[ConfigItem(typeof(CategoriesItem))] public string Categories { get; set; } = "Root";
		[ConfigItem(typeof(CategoriesItem))] public string CategoriesExclude { get; set; }
		[ConfigItem(typeof(IntegerItem))] public int PreviewSize { get; set; } = 800;
		[ConfigItem(typeof(IntegerItem))] public int PageSize { get; set; } = 12;
	}
}