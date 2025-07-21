import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onAddNewPressed;
  final VoidCallback? onPOSPressed;
  final String userAvatarUrl;
  final int notificationCount;
  final Function(String)? onSearchSubmitted;
  final String? selectedBusiness;
  
  const SGHeader({
    super.key,
    this.title = "Dreams POS",
    this.onMenuPressed,
    this.onAddNewPressed,
    this.onPOSPressed,
    this.userAvatarUrl = "",
    this.notificationCount = 0,
    this.onSearchSubmitted,
    this.selectedBusiness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          _buildLogo(),
          const SizedBox(width: 20),
          
          // Search bar
          Expanded(
            child: _buildSearchBar(),
          ),
          const SizedBox(width: 20),
          
          // Business dropdown
          _buildBusinessDropdown(),
          const SizedBox(width: 12),
          
          // Add New button
          _buildAddNewButton(),
          const SizedBox(width: 12),
          
          // POS button
          _buildPOSButton(),
          const SizedBox(width: 20),
          
          // Right side icons
          _buildLanguageSelector(),
          _buildFullscreenButton(),
          _buildMessageButton(),
          _buildNotificationButton(),
          _buildSettingsButton(),
          _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.lock,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        SGText(
          text: title,
          size: 20,
          fontWeight: FontWeight.bold,
          color: SGAppColors.dark,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: SGAppColors.neutral100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SGAppColors.neutral300),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, color: SGAppColors.neutral700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: SGAppColors.neutral500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: onSearchSubmitted,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: SGAppColors.neutral300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '⌘K',
              style: TextStyle(
                color: SGAppColors.neutral700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDropdown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: SGAppColors.neutral300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.store, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 8),
          Text(
            selectedBusiness ?? "Freshmart",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20),
        ],
      ),
    );
  }

  Widget _buildAddNewButton() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onAddNewPressed,
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              "Add New",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPOSButton() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onPOSPressed,
        child: Row(
          children: [
            const Icon(Icons.point_of_sale, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              "POS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: IconButton(
        icon: const Icon(Icons.language),
        color: SGAppColors.neutral700,
        onPressed: () {},
      ),
    );
  }

  Widget _buildFullscreenButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: IconButton(
        icon: const Icon(Icons.fullscreen),
        color: SGAppColors.neutral700,
        onPressed: () {},
      ),
    );
  }

  Widget _buildMessageButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.email_outlined),
            color: SGAppColors.neutral700,
            onPressed: () {},
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            color: SGAppColors.neutral700,
            onPressed: () {},
          ),
          if (notificationCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: IconButton(
        icon: const Icon(Icons.settings_outlined),
        color: SGAppColors.neutral700,
        onPressed: () {},
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: userAvatarUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                userAvatarUrl,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.person,
              color: Colors.white,
            ),
    );
  }
} 