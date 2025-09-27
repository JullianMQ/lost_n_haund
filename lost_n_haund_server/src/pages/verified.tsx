import type { FC } from "hono/jsx";

const Layout: FC = (props) => {
  return (
    <html>
      <head>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <script
          src="https://cdn.jsdelivr.net/npm/@tailwindplus/elements@1"
          type="module"
        ></script>
      </head>
      <body>
        <div class="bg-gray-900 h-full">
          <header class="absolute inset-x-0 top-0 z-50">
            <el-dialog>
              <dialog
                id="mobile-menu"
                class="backdrop:bg-transparent lg:hidden"
              >
                <div tabindex="0" class="fixed inset-0 focus:outline-none">
                  <el-dialog-panel class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-gray-900 p-6 sm:max-w-sm sm:ring-1 sm:ring-gray-100/10">
                    <div class="flex items-center justify-between">
                      <a href="#" class="-m-1.5 p-1.5">
                        <span class="sr-only">Your Company</span>
                        <img
                          src="https://tailwindcss.com/plus-assets/img/logos/mark.svg?color=indigo&shade=500"
                          alt=""
                          class="h-8 w-auto"
                        />
                      </a>
                      <button
                        type="button"
                        command="close"
                        commandfor="mobile-menu"
                        class="-m-2.5 rounded-md p-2.5 text-gray-200"
                      >
                        <span class="sr-only">Close menu</span>
                        <svg
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="1.5"
                          data-slot="icon"
                          aria-hidden="true"
                          class="size-6"
                        >
                          <path
                            d="M6 18 18 6M6 6l12 12"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                          />
                        </svg>
                      </button>
                    </div>
                    <div class="mt-6 flow-root">
                      <div class="-my-6 divide-y divide-white/10">
                        <div class="space-y-2 py-6">
                          <a
                            href="#"
                            class="-mx-3 block rounded-lg px-3 py-2 text-base/7 font-semibold text-white hover:bg-white/5"
                          >
                            Product
                          </a>
                          <a
                            href="#"
                            class="-mx-3 block rounded-lg px-3 py-2 text-base/7 font-semibold text-white hover:bg-white/5"
                          >
                            Features
                          </a>
                          <a
                            href="#"
                            class="-mx-3 block rounded-lg px-3 py-2 text-base/7 font-semibold text-white hover:bg-white/5"
                          >
                            Marketplace
                          </a>
                          <a
                            href="#"
                            class="-mx-3 block rounded-lg px-3 py-2 text-base/7 font-semibold text-white hover:bg-white/5"
                          >
                            Company
                          </a>
                        </div>
                        <div class="py-6">
                          <a
                            href="#"
                            class="-mx-3 block rounded-lg px-3 py-2.5 text-base/7 font-semibold text-white hover:bg-white/5"
                          >
                            Log in
                          </a>
                        </div>
                      </div>
                    </div>
                  </el-dialog-panel>
                </div>
              </dialog>
            </el-dialog>
          </header>

          <div class="relative isolate px-6 pt-14 lg:px-8">
            <div
              aria-hidden="true"
              class="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80"
            >
              <div
                style="clip-path: polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)"
                class="relative left-[calc(50%-11rem)] aspect-1155/678 w-144.5 -translate-x-1/2 rotate-30 bg-linear-to-tr from-[#ff80b5] to-[#9089fc] opacity-30 sm:left-[calc(50%-30rem)] sm:w-288.75"
              ></div>
            </div>
            <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
              <div class="text-center">
                {props.children}
              </div>
            </div>
            <div
              aria-hidden="true"
              class="absolute inset-x-0 top-[calc(100%-13rem)] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[calc(100%-30rem)]"
            >
              <div
                style="clip-path: polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)"
                class="relative left-[calc(50%+3rem)] aspect-1155/678 w-144.5 -translate-x-1/2 bg-linear-to-tr from-[#ff80b5] to-[#9089fc] opacity-30 sm:left-[calc(50%+36rem)] sm:w-288.75"
              ></div>
            </div>
          </div>
        </div>
      </body>
    </html>
  );
};

const Top: FC<{ message: string }> = (props: { message: string }) => {
  return (
    <Layout>
      <h1 class="text-5xl font-semibold tracking-tight text-balance text-white sm:text-7xl">
        Verification complete!
      </h1>
      <p class="mt-8 text-lg font-medium text-pretty text-gray-400 sm:text-xl/8">
        {props.message}
      </p>
    </Layout>
  );
};

export { Top };
