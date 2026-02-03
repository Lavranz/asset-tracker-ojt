import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_card.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';

// Your SearchTicketsPage widget
class TicketsSearchPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Get the query parameter from the GoRouter state
    final query = GoRouter.of(context).state!.uri.queryParameters['query'];
    final queryState = useState(query ?? '');
    final ticketList = useState<List<TicketItem>>([]);
    final filteredTicketList = useState<List<TicketItem>>([]);

    // Function to filter tickets based on query
    void filterTickets(String searchQuery, List<TicketItem> tickets) {
      if (searchQuery.isEmpty) {
        filteredTicketList.value = tickets;
      } else {
        filteredTicketList.value = tickets.where((ticket) {
          return ticket.ticketId
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              ticket.subject.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }
    }

    final ticketListQuery = useQuery(
      "ticket_list_search",
      () => ticket$.list(),
      onData: (data) {
        ticketList.value = data;
        filterTickets(queryState.value, data);
      },
      onError: (e) {},
    );

    // Refetch on mount
    useEffect(() {
      ticketListQuery.refresh();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        title: Text(
            'Found ${filteredTicketList.value.length} ${filteredTicketList.value.length > 1 ? 'tickets' : 'ticket'}',
            style: AppTextTheme.H6MediumPrimary.copyWith(
                fontWeight: FontWeight.w600)),
        centerTitle: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReactiveTextField(
                formControl: FormControl<String>(value: query),
                onChanged: (formControl) => filterTickets(
                    formControl.value.toString(), ticketList.value),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: AppColors.neutral300,
                  ),
                  icon: Icon(
                    PhosphorIcons.magnifyingGlass(),
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            )),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: AppColors.neutral50,
        ),
        child: Column(
          children: [
            // No results message
            if (ticketListQuery.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator())),
            if (!ticketListQuery.isFetching && filteredTicketList.value.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No results found',
                        style: AppTextTheme.H6MediumPrimary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check your search keywords and try again.',
                        style: AppTextTheme.BodySmTertiary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            // Wrap the list of ticket cards in a ListView to make it scrollable
            Expanded(
              child: ListView.builder(
                itemCount: filteredTicketList.value.length,
                itemBuilder: (context, index) {
                  return TicketCard(ticket: filteredTicketList.value[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
