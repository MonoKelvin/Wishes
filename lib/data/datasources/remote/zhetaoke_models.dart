/// 折淘客转链响应（signurl=5，包含完整商品信息）
class ZhetaokeConvertResponse {
  final int status;
  final List<ZhetaokeConvertItem>? content;

  ZhetaokeConvertResponse({required this.status, this.content});

  bool get isSuccess => status == 200;

  factory ZhetaokeConvertResponse.fromJson(Map<String, dynamic> json) {
    return ZhetaokeConvertResponse(
      status: json['status'] as int? ?? 301,
      content: json['content'] is List
          ? (json['content'] as List)
              .map((e) =>
                  ZhetaokeConvertItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class ZhetaokeConvertItem {
  final String? taoId;
  final String? title;
  final String? jianjie;
  final String? pictUrl;
  final String? userType;
  final String? sellerId;
  final String? volume;
  final String? size;
  final String? quanhouJiage;
  final String? tkrate3;
  final String? couponInfoMoney;
  final String? couponInfo;
  final String? smallImages;
  final String? taoTitle;
  final String? provcity;
  final String? shopTitle;
  final String? taobaoUrl;
  final String? categoryName;
  final String? levelOneCategoryName;
  final String? couponClickUrl;
  final String? itemUrl;
  final String? shorturl;
  final String? tkl;
  final String? shopIcon;
  final String? pcDescContent;
  final String? sellCount;
  final String? commentCount;
  final String? score1;
  final String? score2;
  final String? score3;

  ZhetaokeConvertItem({
    this.taoId,
    this.title,
    this.jianjie,
    this.pictUrl,
    this.userType,
    this.sellerId,
    this.volume,
    this.size,
    this.quanhouJiage,
    this.tkrate3,
    this.couponInfoMoney,
    this.couponInfo,
    this.smallImages,
    this.taoTitle,
    this.provcity,
    this.shopTitle,
    this.taobaoUrl,
    this.categoryName,
    this.levelOneCategoryName,
    this.couponClickUrl,
    this.itemUrl,
    this.shorturl,
    this.tkl,
    this.shopIcon,
    this.pcDescContent,
    this.sellCount,
    this.commentCount,
    this.score1,
    this.score2,
    this.score3,
  });

  factory ZhetaokeConvertItem.fromJson(Map<String, dynamic> json) {
    return ZhetaokeConvertItem(
      taoId: json['tao_id']?.toString(),
      title: json['title']?.toString(),
      jianjie: json['jianjie']?.toString(),
      pictUrl: json['pict_url']?.toString(),
      userType: json['user_type']?.toString(),
      sellerId: json['seller_id']?.toString(),
      volume: json['volume']?.toString(),
      size: json['size']?.toString(),
      quanhouJiage: json['quanhou_jiage']?.toString(),
      tkrate3: json['tkrate3']?.toString(),
      couponInfoMoney: json['coupon_info_money']?.toString(),
      couponInfo: json['coupon_info']?.toString(),
      smallImages: json['small_images']?.toString(),
      taoTitle: json['tao_title']?.toString(),
      provcity: json['provcity']?.toString(),
      shopTitle: json['shop_title']?.toString(),
      taobaoUrl: json['taobao_url']?.toString(),
      categoryName: json['category_name']?.toString(),
      levelOneCategoryName: json['level_one_category_name']?.toString(),
      couponClickUrl: json['coupon_click_url']?.toString(),
      itemUrl: json['item_url']?.toString(),
      shorturl: json['shorturl']?.toString(),
      tkl: json['tkl']?.toString(),
      shopIcon: json['shop_icon']?.toString(),
      pcDescContent: json['pcDescContent']?.toString(),
      sellCount: json['sellCount']?.toString(),
      commentCount: json['commentCount']?.toString(),
      score1: json['score1']?.toString(),
      score2: json['score2']?.toString(),
      score3: json['score3']?.toString(),
    );
  }
}

/// 折淘客关键词搜索响应
class ZhetaokeSearchResponse {
  final int status;
  final String? msg;
  final ZhetaokeSearchResult? result;

  ZhetaokeSearchResponse({required this.status, this.msg, this.result});

  bool get isSuccess => status == 200;

  factory ZhetaokeSearchResponse.fromJson(Map<String, dynamic> json) {
    final searchResponse =
        json['tbk_item_search_response'] as Map<String, dynamic>?;
    return ZhetaokeSearchResponse(
      status: json['status'] as int? ?? searchResponse?['status'] as int? ?? 301,
      msg: json['msg']?.toString() ?? searchResponse?['msg']?.toString(),
      result: searchResponse != null
          ? ZhetaokeSearchResult.fromJson(searchResponse)
          : null,
    );
  }
}

class ZhetaokeSearchResult {
  final List<ZhetaokeSearchItem> items;
  final int totalResults;
  final bool hasMore;

  ZhetaokeSearchResult({
    required this.items,
    this.totalResults = 0,
    this.hasMore = false,
  });

  factory ZhetaokeSearchResult.fromJson(Map<String, dynamic> json) {
    final resultList = json['result_list'] as Map<String, dynamic>?;
    final mapData = resultList?['map_data'] as List?;
    return ZhetaokeSearchResult(
      items: mapData
              ?.map((e) =>
                  ZhetaokeSearchItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalResults: json['total_results'] as int? ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class ZhetaokeSearchItem {
  final String? numIid;
  final String? title;
  final String? pictUrl;
  final String? reservePrice;
  final String? zkFinalPrice;
  final String? commissionRate;
  final String? couponInfo;
  final String? shopTitle;
  final int? volume;
  final String? couponShareUrl;
  final String? clickUrl;
  final String? shortUrl;
  final String? smallImages;
  final int? userType;
  final String? nick;
  final String? sellerId;

  ZhetaokeSearchItem({
    this.numIid,
    this.title,
    this.pictUrl,
    this.reservePrice,
    this.zkFinalPrice,
    this.commissionRate,
    this.couponInfo,
    this.shopTitle,
    this.volume,
    this.couponShareUrl,
    this.clickUrl,
    this.shortUrl,
    this.smallImages,
    this.userType,
    this.nick,
    this.sellerId,
  });

  factory ZhetaokeSearchItem.fromJson(Map<String, dynamic> json) {
    String? parseSmallImages(dynamic data) {
      if (data is Map && data['string'] is List) {
        return (data['string'] as List).join('|');
      }
      return data?.toString();
    }

    return ZhetaokeSearchItem(
      numIid: json['num_iid']?.toString(),
      title: json['title']?.toString(),
      pictUrl: json['pict_url']?.toString(),
      reservePrice: json['reserve_price']?.toString(),
      zkFinalPrice: json['zk_final_price']?.toString(),
      commissionRate: json['commission_rate']?.toString(),
      couponInfo: json['coupon_info']?.toString(),
      shopTitle: json['shop_title']?.toString(),
      volume: json['volume'] as int?,
      couponShareUrl: json['coupon_share_url']?.toString(),
      clickUrl: json['click_url']?.toString(),
      shortUrl: json['short_url']?.toString(),
      smallImages: parseSmallImages(json['small_images']),
      userType: json['user_type'] as int?,
      nick: json['nick']?.toString(),
      sellerId: json['seller_id']?.toString(),
    );
  }
}

/// 折淘客推荐商品响应
class ZhetaokeRecommendResponse {
  final ZhetaokeRecommendData? data;

  ZhetaokeRecommendResponse({this.data});

  factory ZhetaokeRecommendResponse.fromJson(Map<String, dynamic> json) {
    final response =
        json['tbk_dg_optimus_material_response'] as Map<String, dynamic>?;
    return ZhetaokeRecommendResponse(
      data: response != null
          ? ZhetaokeRecommendData.fromJson(response)
          : null,
    );
  }
}

class ZhetaokeRecommendData {
  final List<ZhetaokeRecommendItem> items;

  ZhetaokeRecommendData({required this.items});

  factory ZhetaokeRecommendData.fromJson(Map<String, dynamic> json) {
    final resultList = json['result_list'] as Map<String, dynamic>?;
    final mapData = resultList?['map_data'] as List?;
    return ZhetaokeRecommendData(
      items: mapData
              ?.map((e) => ZhetaokeRecommendItem.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ZhetaokeRecommendItem {
  final int? itemId;
  final String? title;
  final String? shortTitle;
  final String? pictUrl;
  final String? reservePrice;
  final String? zkFinalPrice;
  final int? volume;
  final String? commissionRate;
  final int? couponAmount;
  final String? couponClickUrl;
  final String? clickUrl;
  final String? shopTitle;
  final String? nick;
  final int? sellerId;
  final int? userType;
  final String? categoryName;
  final int? couponRemainCount;
  final int? couponTotalCount;
  final String? smallImages;
  final String? whiteImage;
  final String? xId;

  ZhetaokeRecommendItem({
    this.itemId,
    this.title,
    this.shortTitle,
    this.pictUrl,
    this.reservePrice,
    this.zkFinalPrice,
    this.volume,
    this.commissionRate,
    this.couponAmount,
    this.couponClickUrl,
    this.clickUrl,
    this.shopTitle,
    this.nick,
    this.sellerId,
    this.userType,
    this.categoryName,
    this.couponRemainCount,
    this.couponTotalCount,
    this.smallImages,
    this.whiteImage,
    this.xId,
  });

  factory ZhetaokeRecommendItem.fromJson(Map<String, dynamic> json) {
    String? parseSmallImages(dynamic data) {
      if (data is Map && data['string'] is List) {
        return (data['string'] as List).join('|');
      }
      return data?.toString();
    }

    return ZhetaokeRecommendItem(
      itemId: json['item_id'] as int?,
      title: json['title']?.toString(),
      shortTitle: json['short_title']?.toString(),
      pictUrl: json['pict_url']?.toString(),
      reservePrice: json['reserve_price']?.toString(),
      zkFinalPrice: json['zk_final_price']?.toString(),
      volume: json['volume'] as int?,
      commissionRate: json['commission_rate']?.toString(),
      couponAmount: json['coupon_amount'] as int?,
      couponClickUrl: json['coupon_click_url']?.toString(),
      clickUrl: json['click_url']?.toString(),
      shopTitle: json['shop_title']?.toString(),
      nick: json['nick']?.toString(),
      sellerId: json['seller_id'] as int?,
      userType: json['user_type'] as int?,
      categoryName: json['category_name']?.toString(),
      couponRemainCount: json['coupon_remain_count'] as int?,
      couponTotalCount: json['coupon_total_count'] as int?,
      smallImages: parseSmallImages(json['small_images']),
      whiteImage: json['white_image']?.toString(),
      xId: json['x_id']?.toString(),
    );
  }
}
