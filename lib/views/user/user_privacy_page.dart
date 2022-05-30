import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserPrivacyPage extends StatelessWidget {
  const UserPrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '隐私协议',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  child: Caption(
                    str: 'BEEGOPLUS隐私政策',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.vGap15,
                ...buildProtol(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildProtol() {
    List<String> textList = [
      '重视用户的隐私，隐私权是您重要的权利。您在使用我们的服务时，我们可能会收集和使用您的相关信息。我们希望通过本《BEEGOPLUS隐私政策》向您说明，在使用我们的服务时，我们如何收集、使用、储存和分享这些信息，以及我们为您提供的访问、更新、控制和保护这些信息的方式。本《BEEGOPLUS隐私政策》与您所使用的其明服务息息相关，希望您仔细阅读，在需要时，按照本《BEEGOPLUS隐私政策》的指引，作出您认为适当的选择。本《BEEGOPLUS隐私政策》中涉及的相关技术词汇，我们尽量以简明扼要的表述，并提供进一步说明的链接，以便您的理解。',
      '您使用或继续使用我们的服务，即意味着同意我们按照本《BEEGOPLUS隐私政策》收集、使用、储存和分享您的相关信息。',
      '如对本《BEEGOPLUS隐私政策》或相关事宜有任何问题，请通过majingzhi1@beegoplus.com与我们联系。',
      '我们可能收集的信息 我们提供服务时，可能会收集、储存和使用下列与您有关的信息。如果您不提供相关信息，可能无法注册成为我们的用户或无法享受我们提供的某些服务，或者无法达到相关服务拟达到的效果。 您提供的信息 您在注册账户或使用我们的服务时，向我们提供的相关个人信息，例如电话号码、电子邮件或银行卡号等； 您通过我们的服务向其他方提供的共享信息，以及您使用我们的服务时所储存的信息。',
      '其他方使用我们的服务时所提供有关您的共享信息。 我们获取的您的信息 您使用服务时我们可能收集如下信息：',
      '日志信息，指您使用我们的服务时，系统可能通过cookies、web beacon或其他方式自动采集的技术信息，包括：设备或软件信息，例如您的移动设备、网页浏览器或用于接入我们服务的其他程序所提供的配置信息、您的IP地址和移动设备所用的版本和设备识别码；',
      '在使用我们服务时搜索或浏览的信息，例如您使用的网页搜索词语、访问的社交媒体页url地址，以及您在使用我们服务时浏览或要求提供的其他信息和内容详情；有关您曾使用的移动应用（APP）和其他软件的信息，以及您曾经使用该等移动应用和软件的信息；',
      '您通过我们的服务进行通讯的信息，例如曾通讯的账号，以及通讯时间、数据和时长；',
      '位置信息，指您开启设备定位功能并使用我们基于位置提供的相关服务时，收集的有关您位置的信息，包括：',
      '您通过具有定位功能的移动设备使用我们的服务时，通过GPS或WiFi等方式收集的您的地理位置信息；',
      '您或其他用户提供的包含您所处地理位置的实时信息，例如您提供的账户信息中包含的您所在地区信息，您或其他人上传的显示您当前或曾经所处地理位置的共享信息，您或其他人共享的照片包含的地理标记信息；',
      '您可以通过关闭定位功能，停止对您的地理位置信息的收集。',
      '我们可能将在向您提供服务的过程之中所收集的信息用作下列用途：',
      '向您提供服务；',
      '在我们提供服务时，用于身份验证、客户服务、安全防范、诈骗监测、存档和备份用途，确保我们向您提供的产品和服务的安全性；',
      '帮助我们设计新服务，改善我们现有服务；',
      '使我们更加了解您如何接入和使用我们的服务，从而针对性地回应您的个性化需求，例如语言设定、 位置设定、个性化的帮助服务和指示，或对您和其他用户作出其他方面的回应；',
      '向您提供与您更加相关的广告以替代普遍投放的广告；评估我们服务中的广告和其他促销及推广活动的效果，并加以改善；软件认证或管理软件升级；让您参与有关我们产品和服务的调查。',
      '为了让您有更好的体验、改善我们的服务或您同意的其他用途，在符合相关法律法规的前提下，我们可能将通过某一项服务所收集的信息，以汇集信息或者个性化的方式，用于我们的其他服务。例如，在您使用我们的一项服务时所收集的信息，可能在另一服务中用于向您提供特定内容，或向您展示与您相关的、非普遍推送的信息。如果我们在相关服务中提供了相应选项，您也可以授权我们将该服务所提供和储存的信息用于我们的其他服务。 您如何访问和控制自己的个人信息',
      '我们将尽一切可能采取适当的技术手段，保证您可以访问、更新和更正自己的注册信息或使用我们的服务时提供的其他个人信息。在访问、更新、更正和删除前述信息时，我们可能会要求您进行身份验证，以保障账户安全。',
      '我们可能分享的信息',
      '除以下情形外，未经您同意，我们以及我们的关联公司不会与任何第三方分享您的个人信息。',
      '我们以及我们的关联公司，可能将您的个人信息与我们的关联公司、合作伙伴及第三方服务供应商、承包商及代理（例如代表我们发出电子邮件或推送通知的通讯服务提供商、为我们提供位置数据的地图服务供应商）分享（他们可能并非位于您所在的法域），用作下列用途：',
      '向您提供我们的服务；',
      '实现“我们可能如何使用信息”部分所述目的；',
      '履行我们在本《BEEGOPLUS隐私政策》中的义务和行使我们的权利； 理解、维护和改善我们的服务。 如我们或我们的关联公司与任何上述第三方分享您的个人信息，我们将努力确保该等第三方在使用您的个人信息时遵守本《BEEGOPLUS隐私政策》及我们要求其遵守的其他适当的保密和安全措施。',
      '随着我们业务的持续发展，我们以及我们的关联公司有可能进行合并、收购、资产转让或类似的交易，您的个人信息有可能作为此类交易的一部分而被转移。我们将在转移前通知您。',
      '我们或我们的关联公司还可能为以下需要而保留、保存或披露您的个人信息：',
      '遵守适用的法律法规；',
      '遵守法院命令或其他法律程序的规定；',
      '遵守相关政府机关的要求。',
      '为遵守适用的法律法规、维护社会公共利益，或保护我们的客户、我们或我们的集团公司、其他用户或雇员的人身和财产安全或合法权益所合理必需的用途。',
    ];
    List<Widget> list = [];
    for (var v in textList) {
      list.add(Container(
        alignment: Alignment.centerLeft,
        child: Text(
          '        $v',
          style: const TextStyle(
            height: 1.7,
          ),
        ),
      ));
    }
    return list;
  }
}
