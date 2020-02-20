using SunEngine.Core.Configuration.ConfigItemType;

namespace SunEngine.Core.SectionsData
{
	public class PostsClientSectionData
	{
		[ConfigItem(typeof(StringItem))]
		public string Title { get; set; }
		[ConfigItem(typeof(StringItem))]
		public string SubTitle { get; set; }
		[ConfigItem(typeof(StringItem))]
		public string Header { get; set; }
		[ConfigItem(typeof(CategoriesItem))]
		public string Categories { get; set; }
		[ConfigItem(typeof(CategoriesItem))]
		public string CategoriesExclude { get; set; }
		[ConfigItem(typeof(BooleanItem))]
		public bool ShowAuthor { get; set; }
		[ConfigItem(typeof(BooleanItem))]
		public bool ShowPublishDate { get; set; }
		[ConfigItem(typeof(BooleanItem))]
		public bool ShowReadNext { get; set; }
		[ConfigItem(typeof(BooleanItem))]
		public bool ShowComments { get; set; }
	}
}