import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favourite_new_model.dart';

List<String> checkSelectedInterest(BuildContext context) {
  InterestProvider interestProvider =
      Provider.of<InterestProvider>(context, listen: false);
  List<String> selectedInterests = [];
  interestProvider.getSubCategories.values.forEach((interest) {
    (interest as Map).values.forEach((isSelected) {
      if (isSelected[0] == true) {
        List<String> keys = (interest as Map<String, dynamic>).keys.toList();
        keys.forEach((element) {
          if (interest[element] == isSelected) selectedInterests.add(element);
        });
      }
    });
  });
  return selectedInterests;
}

setInterestCategory(BuildContext context) async {
  var _catList = await locator.get<InterestService>().getInterestCategory();
  if (_catList != null) {
    Provider.of<InterestProvider>(context, listen: false).categories = _catList;
  }
}

setInterestSubCategory(BuildContext context, String cat) async {
  var _subCatList =
      await locator.get<InterestService>().getInterestSubCategory(cat);
  if (_subCatList.isNotEmpty) {
    Provider.of<InterestProvider>(context, listen: false).subCategories =
        _subCatList;
  }
}

setSearchInterestSubCategory(BuildContext context, String subcat) async {
  var _subCatList =
  await locator.get<InterestService>().getSearchInterestSubCategory(subcat);
  Provider.of<InterestProvider>(context, listen: false).subCategories =
      _subCatList;
}

List<FavouriteModelNew> setFav(BuildContext context, Map<String, dynamic> favourites) {
  {
    List<FavouriteModelNew> favouriteList = [];
    Map<String, dynamic> result = favourites;
    Map<String, dynamic> data = Map<String, dynamic>();
    for (dynamic type in result.keys) {
      data[type.toString()] = result[type];
    }
    if(data['Song']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Song';
      f1.icon = musicIcon;
      f1.bg = bluebg;
      f1.iconbg = bluelogobg;
      f1.favourite = data['Song'].toString();
      favouriteList.add(f1);
    }
    if(data['Actor/Actress']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Actor/Actress';
      f1.icon = videoIcon;
      f1.bg = greenbg;
      f1.iconbg = greenlogobg;
      f1.favourite = data['Actor/Actress'].toString();
      favouriteList.add(f1);
    }
    if(data['Movie']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Movie';
      f1.icon = videoIcon;
      f1.bg = purplebg;
      f1.iconbg = purplelogobg;
      f1.favourite = data['Movie'].toString();
      favouriteList.add(f1);
    }
    if(data['Cuisine']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Cuisine';
      f1.icon = cookingIcon;
      f1.bg = violetbg;
      f1.iconbg = violetlogobg;
      f1.favourite = data['Cuisine'].toString();
      favouriteList.add(f1);
    }
    if(data['Dance Style']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Dance Style';
      f1.icon = videoIcon;
      f1.bg = yellowbg;
      f1.iconbg = yellowlogobg;
      f1.favourite = data['Dance Style'].toString();
      favouriteList.add(f1);
    }
    if(data['City']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'City';
      f1.icon = locationpIcon;
      f1.bg = indigobg;
      f1.iconbg = indigologobg;
      f1.favourite = data['City'].toString();
      favouriteList.add(f1);
    }
    if(data['Author']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Author';
      f1.icon = videoIcon;
      f1.bg = yellowbg;
      f1.iconbg = yellowlogobg;
      f1.favourite = data['Author'].toString();
      favouriteList.add(f1);
    }
    if(data['Genre']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Genre';
      f1.icon = videoIcon;
      f1.bg = indigobg;
      f1.iconbg = indigologobg;
      f1.favourite = data['Genre'].toString();
      favouriteList.add(f1);
    }
    if(data['Music Style']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Music Style';
      f1.icon = musicIcon;
      f1.bg = purplebg;
      f1.iconbg = purplelogobg;
      f1.favourite = data['Music Style'].toString();
      favouriteList.add(f1);
    }
    if(data['Fashion Designer']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Fashion Designer';
      f1.icon = videoIcon;
      f1.bg = indigobg;
      f1.iconbg = indigologobg;
      f1.favourite = data['Fashion Designer'].toString();
      favouriteList.add(f1);
    }
    if(data['TV Series']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'TV Series';
      f1.icon = videoIcon;
      f1.bg = yellowbg;
      f1.iconbg = yellowlogobg;
      f1.favourite = data['TV Series'].toString();
      favouriteList.add(f1);
    }
    if(data['Startup']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Startup';
      f1.icon = videoIcon;
      f1.bg = indigobg;
      f1.iconbg = indigologobg;
      f1.favourite = data['Startup'].toString();
      favouriteList.add(f1);
    }
    if(data['Clothing Brand']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Clothing Brand';
      f1.icon = videoIcon;
      f1.bg = yellowbg;
      f1.iconbg = yellowlogobg;
      f1.favourite = data['Clothing Brand'].toString();
      favouriteList.add(f1);
    }
    if(data['Entrepreneur']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Entrepreneur';
      f1.icon = videoIcon;
      f1.bg = greenbg;
      f1.iconbg = greenlogobg;
      f1.favourite = data['Entrepreneur'].toString();
      favouriteList.add(f1);
    }
    if(data['Artist']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Artist';
      f1.icon = videoIcon;
      f1.bg = purplebg;
      f1.iconbg = purplelogobg;
      f1.favourite = data['Artist'].toString();
      favouriteList.add(f1);
    }
    if(data['Color']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Color';
      f1.icon = videoIcon;
      f1.bg = indigobg;
      f1.iconbg = indigologobg;
      f1.favourite = data['Color'].toString();
      favouriteList.add(f1);
    }
    if(data['Painting']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Painting';
      f1.icon = videoIcon;
      f1.bg = yellowbg;
      f1.iconbg = yellowlogobg;
      f1.favourite = data['Painting'].toString();
      favouriteList.add(f1);
    }
    if(data['Book']!=null)
    {
      FavouriteModelNew f1 = new FavouriteModelNew();
      f1.label = 'Book';
      f1.icon = bookmarkIcon;
      f1.bg = bluebg;
      f1.iconbg = bluelogobg;
      f1.favourite = data['Book'].toString();
      favouriteList.add(f1);
    }
    return favouriteList;
  }
}

getUserInterest(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var interestProvider = Provider.of<InterestProvider>(context, listen: false);
  List<SubCategory> intList = await locator
      .get<InterestService>()
      .getUserInterests(userProvider.currentUser.interestList);
  if (intList != null) {
    interestProvider.userInterest = intList;
    // print('interestProvider..userInterest ${interestProvider.userInterest[0].name}');
  }
}
