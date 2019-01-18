﻿using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SunEngine.Commons.Models;
using SunEngine.Commons.Services;
using SunEngine.Stores;
using IAuthorizationService = SunEngine.Commons.Services.IAuthorizationService;

namespace SunEngine.Controllers
{
    public class CategoriesController : BaseController
    {
        private readonly OperationKeysContainer OperationKeys;

        private readonly IAuthorizationService authorizationService;
        private readonly ICategoriesStore categoriesStore;
        private readonly IUserGroupStore userGroupStore;

        public CategoriesController(IUserGroupStore userGroupStore,
            ICategoriesStore categoriesStore,
            IAuthorizationService authorizationService, 
            OperationKeysContainer operationKeysContainer,
            UserManager<User> userManager) : base(userManager)
        {
            OperationKeys = operationKeysContainer;
            
            this.authorizationService = authorizationService;
            this.categoriesStore = categoriesStore;
            this.userGroupStore = userGroupStore;
        }

        [HttpPost]
        [HttpGet]  // For pulse and testing 
        public CategoryInfoWithAccesses GetAllCategoriesAndAccesses()
        {
            var rez = CategoryInfoWithAccessesFromCategory(categoriesStore.RootCategory);
            return rez;
        }

        private CategoryInfoWithAccesses CategoryInfoWithAccessesFromCategory(Category category)
        {
            // TODO сделать самостоятельную функцию которая проходит от корня 
            // TODO идя сначала по ближайшим к корню нодам и потом ниже

            if (!authorizationService.HasAccess(User.UserGroups, category,
                OperationKeys.MaterialAndMessagesRead) && category.Id != categoriesStore.RootCategory.Id)
            {
                return null;
            }
            
            CategoryInfoWithAccesses categoryInfo = new CategoryInfoWithAccesses
            {
                Id = category.Id,
                Name = category.Name.ToLower(),
                Title = category.Title,
                Header = category.Header,
                ChildrenType = category.ChildrenType,
                AreaRoot = category.AreaRoot,
                CategoryPersonalAccess = DetectPersonalAccesses(category)
            };

            if (category.SubCategories != null && category.SubCategories.Count > 0)
            {
                categoryInfo.SubCategories = new List<CategoryInfoWithAccesses>(category.SubCategories.Count);

                foreach (var child in category.SubCategories)
                {
                    var childInfo = CategoryInfoWithAccessesFromCategory(child);
                    if (childInfo == null)
                    {
                        continue;
                    }
                    categoryInfo.SubCategories.Add(childInfo);
                }
            }

            return categoryInfo;
        }

        private Dictionary<string, bool> DetectPersonalAccesses(Category category)
        {
            Dictionary<string, bool> dict = new Dictionary<string, bool>(userGroupStore.AllOperationKeys.Count);

            foreach (var operationKey in userGroupStore.AllOperationKeys)
            {
                bool allow = authorizationService.HasAccess(User.UserGroups, category,
                    operationKey.OperationKeyId);
                
                if (allow)
                {
                    dict[operationKey.Name] = true;
                }
            }

            return dict;
        }
    }
    
    
    public class CategoryInfoWithAccesses
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
        public string Header { get; set; }
        public bool AreaRoot { get; set; }
        public ChildrenType ChildrenType { get; set; }
        
        public Dictionary<string, bool> CategoryPersonalAccess { get; set; }
        
        public List<CategoryInfoWithAccesses> SubCategories { get; set; }
    }
}