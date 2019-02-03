-- Initalize Banker to use as table to store the addon in it.
if Banker == nil then Banker = {} end

-- Store Addon information to a table
Banker.Addon = {
  name = "Banker",
  version = "2.0.0",
  displayName = GetString(SI_BANKER_NAME),
  author = "Nils-Börge Margotti",
  email = "nilsmargotti@gmail.com",
  website = "https://www.esoui.com/portal.php?uid=6208",
  command = "/banker"
}