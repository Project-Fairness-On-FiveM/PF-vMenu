using System;
using System.Collections.Generic;
using System.Linq;
using MenuAPI;
using Newtonsoft.Json;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;
using static vMenuClient.CommonFunctions;
using static vMenuShared.PermissionsManager;


namespace vMenuClient
{
    public class PluginSettings
    {
        private Menu menu;

        public int majordriftval { get; private set; } = 15;
        public int minordriftval { get; private set; } = 25;
        public Menu EasyDriftPlusMenu { get; private set; }    

        public bool EDPBool { get; private set; }
        public bool WMBool { get; private set; }


        private static readonly LanguageManager Lm = new LanguageManager();

        private void CreateMenu()
        {
            // Create the menu
            menu = new Menu(Game.Player.Name, "Plugins Menu");

            MenuItem easydpm = new MenuItem("Easy Drift Plus", "Easy Drift Plus Plugin Controls.")
            {
                Label = "(~g~Plugin~s~) →→→"
            };

            menu = new Menu(Game.Player.Name, "Plugins Menu");

            MenuItem wmstatus = new MenuItem("Wheelie Manager", "Wheelie Manager Status.")
            {
                Label = "(~g~Plugin~s~)"
            };

            #region 
            EasyDriftPlusMenu = Lm.GetMenu(new Menu("Easy Drift Plus Menu", "Easy Drift Plus Menu"));

            MenuController.AddSubmenu(menu, EasyDriftPlusMenu);            


            #endregion

            #region
            MenuController.BindMenuItem(menu, EasyDriftPlusMenu, easydpm);

            #endregion

            #region
            TriggerEvent("vMenu:EasyDriftPlus", new Action<bool>((Bool) =>
            {
                EDPBool = Bool;
            }));
            if (IsAllowed(Permission.PNEasyDrift))
            {           
                if (EDPBool)
                {
                    menu.AddMenuItem(easydpm);
                } 
                else
                {
                    menu.AddMenuItem(easydpm);
    
                    easydpm.Enabled = false;
                    easydpm.LeftIcon = MenuItem.Icon.LOCK;
                    easydpm.Description = "This plugin isn't enabled.";
                    easydpm.Label = "(~r~Plugin~s~) →→→";
    
                }  
            }
            else
            {
                menu.AddMenuItem(easydpm);
    
                easydpm.Enabled = false;
                easydpm.LeftIcon = MenuItem.Icon.LOCK;
                easydpm.Description = "This plugin isn't enabled or the server administration has blocked it from being used.";
                easydpm.Label = "(~r~Plugin~s~) →→→";

            }

            TriggerEvent("vMenu:WheelieManager", new Action<bool>((Bool) =>
            {
                WMBool = Bool;
            }));
                if (WMBool)
                {
                    menu.AddMenuItem(wmstatus);
                } 
                else
                {
                    menu.AddMenuItem(wmstatus);
    
                    wmstatus.Enabled = false;
                    wmstatus.LeftIcon = MenuItem.Icon.LOCK;
                    wmstatus.Description = "This plugin isn't enabled.";
                    wmstatus.Label = "(~r~Plugin~s~)";
    
                }  
            


            #endregion

            #region Easy Drift Plus Submenu
                MenuCheckboxItem toggleeasydrift = new MenuCheckboxItem("Toggle Easy Drift Plus", "Enable or disable Easy Drift Plus.", false);
                MenuCheckboxItem toggleeasydriftdisplay = new MenuCheckboxItem("Toggle Easy Drift Display", "Enable or disable Easy Drift Display.", false);
                TriggerEvent("vMenu:toggleEasyDriftupdatemajorv", new Action<int>((majordriftvalupdate) =>
                {
                    majordriftval = majordriftvalupdate;
                }));
                TriggerEvent("vMenu:toggleEasyDriftupdateminorv", new Action<int>((minordriftvalupdate) =>
                {
                    minordriftval = minordriftvalupdate;
                }));


                MenuSliderItem edslider = new MenuSliderItem($"Major Assist Adjust (~g~{majordriftval}°~s~)", 10, 60, (majordriftval*2), false)
                {
                    BarColor = System.Drawing.Color.FromArgb(155, 10, 0, 255),
                    BackgroundColor = System.Drawing.Color.FromArgb(200, 79, 79, 79),

                };
                MenuSliderItem medslider = new MenuSliderItem($"Minor Assist Adjust (~g~{minordriftval}°~s~)", 30, 100, (minordriftval*2), false)
                {
                    BarColor = System.Drawing.Color.FromArgb(155, 163, 13, 13),
                    BackgroundColor = System.Drawing.Color.FromArgb(200, 79, 79, 79),

                };

                EasyDriftPlusMenu.AddMenuItem(toggleeasydrift);
                EasyDriftPlusMenu.AddMenuItem(toggleeasydriftdisplay);
                
                EasyDriftPlusMenu.AddMenuItem(edslider);
                EasyDriftPlusMenu.AddMenuItem(medslider);
            #endregion

            EasyDriftPlusMenu.OnCheckboxChange += (sender, item, index, _checked) =>
            {
                if (item == toggleeasydrift)
                {
                    TriggerEvent("vMenu:toggleEasyDrift", _checked);
                }
                if (item == toggleeasydriftdisplay)
                {
                    TriggerEvent("vMenu:toggleEasyDriftDisplay", _checked);
                }
            };


            EasyDriftPlusMenu.OnSliderPositionChange += (sender, item, oldPos, newPos, itemIndex) =>
            {
                if (item == edslider)
                {

                    TriggerEvent("vMenu:toggleEasyDriftChangeVal", newPos);
                    edslider.Text = $"Major Assist Adjust (~g~{(float)newPos / 2}°~s~)";

                }
                if (item == medslider)
                {
                    TriggerEvent("vMenu:toggleEasyDriftChangeValm", newPos);
                    medslider.Text = $"Minor Assist Adjust (~g~{(float)newPos / 2}°~s~)";
                }
            };

        }


        /// <summary>
        /// Create the menu if it doesn't exist, and then returns it.
        /// </summary>
        /// <returns>The Menu</returns>
        public Menu GetMenu()
        {
            if (menu == null)
            {
                CreateMenu();
            }
            return menu;
        }
        
    }
}
