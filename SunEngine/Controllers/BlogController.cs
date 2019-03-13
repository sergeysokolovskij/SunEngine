using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using SunEngine.Cache;
using SunEngine.Cache.CacheModels;
using SunEngine.Configuration.Options;
using SunEngine.Presenters;
using SunEngine.Presenters.PagedList;
using SunEngine.Security.Authorization;

namespace SunEngine.Controllers
{
    public class BlogController : BaseController
    {
        protected readonly OperationKeysContainer OperationKeys;

        protected readonly BlogOptions blogOptions;
        protected readonly ICategoriesCache categoriesCache;
        protected readonly IAuthorizationService authorizationService;
        protected readonly IBlogPresenter blogPresenter;


        public BlogController(IOptions<BlogOptions> blogOptions,
            IAuthorizationService authorizationService,
            ICategoriesCache categoriesCache,
            OperationKeysContainer operationKeysContainer,
            IBlogPresenter blogPresenter,
            IServiceProvider serviceProvider) : base(serviceProvider)
        {
            OperationKeys = operationKeysContainer;

            this.blogOptions = blogOptions.Value;
            this.authorizationService = authorizationService;
            this.categoriesCache = categoriesCache;
            this.blogPresenter = blogPresenter;
        }

        [HttpPost]
        public virtual async Task<IActionResult> GetPosts(string categoryName, int page = 1)
        {
            var category = categoriesCache.GetCategory(categoryName);

            if (category == null)
            {
                return BadRequest();
            }

            if (!authorizationService.HasAccess(User.Roles, category, OperationKeys.MaterialAndCommentsRead))
            {
                return Unauthorized();
            }

            async Task<IPagedList<PostViewModel>> LoadDataAsync()
            {
                return await blogPresenter.GetPostsAsync(category.Id, page, blogOptions.PostsPageSize);
            }

            return await CacheContentAsync(category, category.Id, LoadDataAsync, page);
        }

        [HttpPost]
        public virtual async Task<IActionResult> GetPostsFromMultiCategories(string categoriesNames, int page = 1)
        {
            var materialsCategoriesDic = categoriesCache.GetAllCategoriesIncludeSub(categoriesNames);

            IList<CategoryCached> categoriesList = authorizationService.GetAllowedCategories(User.Roles, materialsCategoriesDic.Values,
                OperationKeys.MaterialAndCommentsRead);

            if (categoriesList.Count == 0)
            {
                return BadRequest("No categories to show");
            }

            var categoriesIds = categoriesList.Select(x => x.Id).ToArray();

            var rez = await blogPresenter.GetPostsFromMultiCategoriesAsync(categoriesIds, page, blogOptions.PostsPageSize);

            return Json(rez);

            /*async Task<IPagedList<PostViewModel>> LoadDataAsync()
            {
               return await blogPresenter.GetPostsFromMultiCategoriesAsync(categoriesIds, page, blogOptions.PostsPageSize);
            }

            var blogCategory = categoriesCache.GetCategory(categoriesNames);
            return await CacheContentAsync(blogCategory, categoriesIds, LoadDataAsync);*/
        }
    }
}