{
    function toggleTabBar() {
        if (tabStrip.childNodes.length === 2) {
            header.style.height = '0px';
            header.style.minHeight = '0px';
            header.style.opacity = '0';
        }
        else {
            header.style.height = '35px';
            header.style.minHeight = '35px';
            header.style.opacity = '1';
        }
    }

    function observeTabs() {
        toggleTabBar();
        var observer = new MutationObserver(function (mutations) {
            mutations.forEach(toggleTabBar);
        })
        var observerConfig = {
            childList: true
        }
        observer.observe(tabStrip, observerConfig);
    }

    setTimeout(function wait() {
        header = document.getElementById('header');
        tabStrip = document.querySelector('.tab-strip');

        if (tabStrip) {
            observeTabs();
        }
        else {
            setTimeout(wait, 300);
        }
    }, 300);
}

// //original
// {
//     function toggleTabBar() {
//         if (tabStrip.childNodes.length === 2) {
//             tabsContainer.style.height = '0px';
//             tabsContainer.style.opacity = '0';
//             tabsContainer.style.padding = '0'
//         }
//         else {
//             tabsContainer.style.height = '30px';
//             tabsContainer.style.opacity = '1';
//             tabsContainer.style.padding = '0 0 4px 0';
//         }
//     }

//     function observeTabs() {
//         toggleTabBar();
//         var observer = new MutationObserver(function(mutations) {
//             mutations.forEach(toggleTabBar);
//         })
//         var observerConfig = {
//             childList: true
//         }
//         observer.observe(tabStrip, observerConfig);
//     }

//     setTimeout(function wait() {
//         tabsContainer = document.getElementById('tabs-tabbar-container');
//         tabStrip = document.querySelector('.tab-strip');
//         if (tabStrip) {
//         observeTabs();
//         }
//         else {
//             setTimeout(wait, 300);
//         }
//     }, 300);
// }